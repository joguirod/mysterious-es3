import React from 'react';

interface Sale {
  id: string;
  books: {
    title: string;
  };
  quantity: number;
  total_price: number;
}

interface Props {
  sales: Sale[];
}

export default function RecentSales({ sales }: Props) {
  return (
    <div className="overflow-x-auto">
      <table className="min-w-full">
        <thead>
          <tr>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Product
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Quantity
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Total
            </th>
          </tr>
        </thead>
        <tbody className="bg-white divide-y divide-gray-200">
          {sales.map((sale) => (
            <tr key={sale.id}>
              <td className="px-6 py-4 whitespace-nowrap">
                {sale.books.title}
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                {sale.quantity}
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                ${sale.total_price}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}