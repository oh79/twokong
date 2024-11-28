from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
from transformers import BertTokenizer, BertModel
import torch
import numpy as np
from fastapi.responses import JSONResponse

app = FastAPI()

# BERT 모델 로드
tokenizer = BertTokenizer.from_pretrained('bert-base-multilingual-cased')
model = BertModel.from_pretrained('bert-base-multilingual-cased')

# CORS 미들웨어 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 모든 도메인 허용 (보안을 위해 실제 배포 시 특정 도메인만 허용하는 것이 좋습니다)
    allow_credentials=True,
    allow_methods=["*"],  # 모든 HTTP 메소드 허용
    allow_headers=["*"],  # 모든 헤더 허용
)

# 데이터 모델 정의
class Policy(BaseModel):
    id: str
    eligibility: str
    target: str
    tags: List[str]
    title: str
    organization: str

    # Pydantic 모델을 dict로 변환하여 JSON으로 직렬화 가능하도록 함
    def dict(self, *args, **kwargs):
        return super().dict(*args, **kwargs)

class UserRequest(BaseModel):
    age: int
    occupation: str
    stressFactors: List[str]
    policies: List[Policy]

# 텍스트를 BERT 벡터로 변환
def get_embedding(text):
    # 텍스트를 UTF-8로 인코딩 후 디코딩하여 처리
    text = text.encode('utf-8').decode('utf-8')
    inputs = tokenizer(text, return_tensors='pt', truncation=True, padding=True)
    with torch.no_grad():
        outputs = model(**inputs)
    # 1D 벡터로 변환 (평균 풀링 후 차원 축소)
    return outputs.last_hidden_state.mean(dim=1).squeeze().numpy()

# 유사도 계산 함수 (Cosine Similarity)
def cosine_similarity(vec1, vec2):
    similarity = np.dot(vec1, vec2) / (np.linalg.norm(vec1) * np.linalg.norm(vec2))
    print(f"Similarity: {similarity}")  # 유사도 값 출력
    return similarity

@app.post("/similarity")
async def recommend_policies(request: UserRequest):
    # 사용자 데이터를 하나의 텍스트로 합쳐서 벡터로 변환
    user_factors = f"{request.age} {request.occupation} {' '.join(request.stressFactors)}"
    user_vector = get_embedding(user_factors)

    recommended_policies = []

    for policy in request.policies:
        # 정책의 eligibility, target, tags를 합쳐서 벡터로 변환
        policy_text = f"{policy.eligibility} {policy.target} {' '.join(policy.tags)}"
        policy_vector = get_embedding(policy_text)
        
        # 유사도 계산
        similarity = cosine_similarity(user_vector, policy_vector)

        # 임계값을 넘는 유사도만 추천
        if similarity >= 0.68:  # 임계값 설정
            recommended_policies.append(policy)
        else:
            print(f"Policy {policy.title} does not meet the similarity threshold.")

    # recommended_policies 리스트의 각 객체를 dict로 변환하여 반환
    return JSONResponse(content={"recommended_policies": [policy.dict() for policy in recommended_policies]}, headers={"Content-Type": "application/json; charset=utf-8"})
