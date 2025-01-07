import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080/api',
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const authApi = {
  login: async (email: string, senha: string) => {
    const response = await api.post('/auth/login', { email, senha });
    return response.data;
  },
};

export const booksApi = {
  getTodos: async () => {
    const response = await api.get('/livros');
    return response.data;
  },
  criar: async (livro: any) => {
    const response = await api.post('/livros', livro);
    return response.data;
  },
  excluir: async (id: string) => {
    const response = await api.delete(`/livros/${id}`);
    return response.data;
  },
};

export const salesApi = {
  getEstatisticas: async () => {
    const response = await api.get('/vendas/estatisticas');
    return response.data;
  },
  getVendasRecentes: async () => {
    const response = await api.get('/vendas/recentes');
    return response.data;
  },
};

export default api;