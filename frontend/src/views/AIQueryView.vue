<template>
  <div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold mb-6">AI设备维护助手</h1>
    
    <div class="mb-6">
      <textarea 
        v-model="query" 
        class="w-full p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" 
        rows="4" 
        placeholder="请输入您的问题..."
      ></textarea>
      <button 
        @click="sendQuery" 
        class="mt-4 bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded"
      >
        <i class="fa fa-paper-plane mr-2"></i>发送查询
      </button>
    </div>
    
    <div v-if="responses.length > 0" class="space-y-6">
      <div v-for="(response, index) in responses" :key="index" class="bg-gray-100 p-4 rounded-lg">
        <div class="font-bold mb-2 flex items-center">
          <i class="fa fa-question-circle text-blue-500 mr-2"></i>
          问题: {{ response.query }}
        </div>
        <div class="prose max-w-none mt-3">
          <div class="flex items-start">
            <i class="fa fa-robot text-green-500 mt-1 mr-3"></i>
            <div v-html="response.answer"></div>
          </div>
        </div>
        
        <div v-if="response.similarKnowledge.length > 0" class="mt-6">
          <h3 class="font-bold text-lg mb-2">相关知识库:</h3>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div v-for="(knowledge, kIndex) in response.similarKnowledge" :key="kIndex" class="bg-white p-4 rounded-lg border border-gray-200 hover:shadow-md transition-shadow">
              <h4 class="font-bold text-blue-600 mb-2">{{ knowledge.title }}</h4>
              <p class="text-gray-700 line-clamp-3">{{ knowledge.content }}</p>
              <button @click="showKnowledgeDetail(knowledge)" class="mt-2 text-sm text-blue-500 hover:underline">查看详情</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { aiQuery, getSimilarKnowledge } from '@/api/ai'
import { useRouter } from 'vue-router'

const router = useRouter()
const query = ref('')
const responses = ref([])
const loading = ref(false)

const sendQuery = async () => {
  if (!query.value.trim()) return
  
  loading.value = true
  
  try {
    // 获取AI回答
    const answerResponse = await aiQuery(query.value)
    
    // 获取相似知识库
    const similarResponse = await getSimilarKnowledge(query.value)
    
    responses.value.push({
      query: query.value,
      answer: answerResponse.data,
      similarKnowledge: similarResponse.data
    })
    
    query.value = ''
  } catch (error) {
    console.error('查询失败:', error)
    alert('查询失败，请重试')
  } finally {
    loading.value = false
  }
}

const showKnowledgeDetail = (knowledge) => {
  router.push({ name: 'KnowledgeDetail', params: { id: knowledge.id } })
}
</script>