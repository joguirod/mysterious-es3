import React from 'react';
import { Trash2 } from 'lucide-react';

interface Book {
  id: string;
  title: string;
  author: string;
  price: number;
  stock: number;
  image_url: string;
}

interface Props {
  book: Book;
  onDelete: (id: string) => void;
}

export default function BookCard({ book, onDelete }: Props) {
  return (
    <div className="bg-white rounded-lg shadow-md p-4">
      <img
        src={book.image_url}
        alt={book.title}
        className="w-full h-40 object-cover rounded-md mb-3"
      />
      <h3 className="text-lg font-bold mb-1 truncate">{book.title}</h3>
      <p className="text-gray-600 mb-1 text-sm">by {book.author}</p>
      <p className="text-blue-600 font-bold mb-1">${book.price}</p>
      <p className="text-gray-500 text-sm mb-3">Stock: {book.stock}</p>
      <div className="flex justify-end">
        <button
          onClick={() => onDelete(book.id)}
          className="text-red-600 hover:text-red-800 p-1"
        >
          <Trash2 className="h-5 w-5" />
        </button>
      </div>
    </div>
  );
}