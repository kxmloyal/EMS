import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  timeout: 30000
})

export const aiQuery = (question) => {
  return api.post('/ai/query', { question })
}

export const getSimilarKnowledge = (question) => {
  return api.post('/ai/similar', { question })
}