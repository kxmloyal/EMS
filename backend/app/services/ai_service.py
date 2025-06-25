import openai
import os
from dotenv import load_dotenv

load_dotenv()

class AIService:
    def __init__(self):
        self.openai_api_key = os.getenv('OPENAI_API_KEY')
        self.embedding_model = os.getenv('EMBEDDING_MODEL', 'text-embedding-ada-002')
        self.chat_model = os.getenv('CHAT_MODEL', 'gpt-3.5-turbo')
        openai.api_key = self.openai_api_key
        
    def generate_embedding(self, text):
        response = openai.Embedding.create(
            input=text,
            model=self.embedding_model
        )
        return response['data'][0]['embedding']
    
    def chat_completion(self, messages):
        response = openai.ChatCompletion.create(
            model=self.chat_model,
            messages=messages
        )
        return response.choices[0].message.content
    
    def answer_equipment_question(self, question, context):
        messages = [
            {"role": "system", "content": "你是一个专业的设备维护助手，擅长解答各种设备维护相关的问题。"},
            {"role": "user", "content": f"根据以下设备信息: {context}\n\n回答问题: {question}"}
        ]
        
        return self.chat_completion(messages)