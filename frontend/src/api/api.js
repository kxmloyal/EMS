import axios from 'axios'

const baseURL = import.meta.env.DEV ? '/api' : 'http://your-production-api.com'

const api = axios.create({
  baseURL,
  timeout: 10000
})

// 请求拦截器
api.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
api.interceptors.response.use(
  response => {
    return response.data
  },
  error => {
    console.error('响应错误:', error)
    if (error.response.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

// 设备API
export const equipmentAPI = {
  getEquipmentList(params) {
    return api.get('/equipment', { params })
  },
  getEquipmentById(id) {
    return api.get(`/equipment/${id}`)
  },
  addEquipment(data) {
    return api.post('/equipment', data)
  },
  updateEquipment(id, data) {
    return api.put(`/equipment/${id}`, data)
  },
  deleteEquipment(id) {
    return api.delete(`/equipment/${id}`)
  }
}

// 维护记录API
export const maintenanceAPI = {
  getMaintenanceList(params) {
    return api.get('/maintenance', { params })
  },
  getMaintenanceById(id) {
    return api.get(`/maintenance/${id}`)
  },
  addMaintenance(data) {
    return api.post('/maintenance', data)
  },
  updateMaintenance(id, data) {
    return api.put(`/maintenance/${id}`, data)
  }
}

// 知识库API
export const knowledgeAPI = {
  getKnowledgeList(params) {
    return api.get('/knowledge', { params })
  },
  getKnowledgeById(id) {
    return api.get(`/knowledge/${id}`)
  },
  addKnowledge(data) {
    return api.post('/knowledge', data)
  },
  updateKnowledge(id, data) {
    return api.put(`/knowledge/${id}`, data)
  }
}

// AI查询API
export const aiAPI = {
  query(data) {
    return api.post('/ai/query', data)
  }
}