import React from 'react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';

interface SalesData {
  title: string;
  total: number;
}

interface Props {
  data: SalesData[];
}

export default function SalesChart({ data }: Props) {
  return (
    <div className="h-80">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="title" />
          <YAxis />
          <Tooltip />
          <Bar dataKey="total" fill="#4F46E5" />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}