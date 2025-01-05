import React, { useEffect, useState } from 'react';
import { Plus } from 'lucide-react';
import { supabase } from '../lib/supabase';
import Layout from '../components/Layout';
import BookCard from '../components/books/BookCard';
import AddBookModal from '../components/books/AddBookModal';

interface Book {
  id: string;
  title: string;
  author: string;
  price: number;
  stock: number;
  image_url: string;
  description: string;
}

export default function Products() {
  const [books, setBooks] = useState<Book[]>([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    author: '',
    price: '',
    stock: '',
    image_url: '',
    description: '',
  });

  useEffect(() => {
    fetchBooks();
  }, []);

  const fetchBooks = async () => {
    const { data } = await supabase
      .from('books')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (data) {
      setBooks(data);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const { data, error } = await supabase
      .from('books')
      .insert([
        {
          title: formData.title,
          author: formData.author,
          price: parseFloat(formData.price),
          stock: parseInt(formData.stock),
          image_url: formData.image_url,
          description: formData.description,
        },
      ]);

    if (!error) {
      setIsModalOpen(false);
      setFormData({
        title: '',
        author: '',
        price: '',
        stock: '',
        image_url: '',
        description: '',
      });
      fetchBooks();
    }
  };

  const handleDelete = async (id: string) => {
    const { error } = await supabase
      .from('books')
      .delete()
      .eq('id', id);

    if (!error) {
      fetchBooks();
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
          <h1 className="text-2xl font-bold">Products</h1>
          <button
            onClick={() => setIsModalOpen(true)}
            className="bg-blue-600 text-white px-4 py-2 rounded-md flex items-center hover:bg-blue-700"
          >
            <Plus className="h-5 w-5 mr-2" />
            Add Book
          </button>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {books.map((book) => (
            <BookCard
              key={book.id}
              book={book}
              onDelete={handleDelete}
            />
          ))}
        </div>

        <AddBookModal
          isOpen={isModalOpen}
          onClose={() => setIsModalOpen(false)}
          formData={formData}
          onChange={handleChange}
          onSubmit={handleSubmit}
        />
      </div>
    </Layout>
  );
}