import React, { useEffect, useState } from 'react';
import { Plus } from 'lucide-react';
import { booksApi } from '../lib/api';
import Layout from '../components/Layout';
import BookCard from '../components/books/BookCard';
import AddBookModal from '../components/books/AddBookModal';

interface Livro {
  id: string;
  titulo: string;
  autor: string;
  preco: number;
  estoque: number;
  imagem_url: string;
  descricao: string;
}

export default function Produtos() {
  const [livros, setLivros] = useState<Livro[]>([]);
  const [modalAberto, setModalAberto] = useState(false);
  const [formData, setFormData] = useState({
    titulo: '',
    autor: '',
    preco: '',
    estoque: '',
    imagem_url: '',
    descricao: '',
  });

  useEffect(() => {
    buscarLivros();
  }, []);

  const buscarLivros = async () => {
    try {
      const data = await booksApi.getTodos();
      setLivros(data);
    } catch (erro) {
      console.error('Erro ao buscar livros:', erro);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    try {
      await booksApi.criar({
        titulo: formData.titulo,
        autor: formData.autor,
        preco: parseFloat(formData.preco),
        estoque: parseInt(formData.estoque),
        imagem_url: formData.imagem_url,
        descricao: formData.descricao,
      });

      setModalAberto(false);
      setFormData({
        titulo: '',
        autor: '',
        preco: '',
        estoque: '',
        imagem_url: '',
        descricao: '',
      });
      buscarLivros();
    } catch (erro) {
      console.error('Erro ao criar livro:', erro);
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await booksApi.excluir(id);
      buscarLivros();
    } catch (erro) {
      console.error('Erro ao excluir livro:', erro);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  return (
    <Layout>
      <div className="p-6">
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-2xl font-bold">Produtos</h1>
          <button
            onClick={() => setModalAberto(true)}
            className="bg-blue-600 text-white px-4 py-2 rounded-md flex items-center hover:bg-blue-700"
          >
            <Plus className="h-5 w-5 mr-2" />
            Adicionar Livro
          </button>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {livros.map((livro) => (
            <BookCard
              key={livro.id}
              book={livro}
              onDelete={handleDelete}
            />
          ))}
        </div>

        <AddBookModal
          isOpen={modalAberto}
          onClose={() => setModalAberto(false)}
          formData={formData}
          onChange={handleChange}
          onSubmit={handleSubmit}
        />
      </div>
    </Layout>
  );
}