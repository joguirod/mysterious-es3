import React, { useEffect, useState } from 'react';
import { DollarSign, Package, TrendingUp } from 'lucide-react';
import { supabase } from '../lib/supabase';
import Layout from '../components/Layout';
import StatCard from '../components/dashboard/StatCard';
import SalesChart from '../components/dashboard/SalesChart';
import RecentSales from '../components/dashboard/RecentSales';

interface SalesData {
  title: string;
  total: number;
}

export default function Dashboard() {
  const [totalRevenue, setTotalRevenue] = useState(0);
  const [totalProducts, setTotalProducts] = useState(0);
  const [topProducts, setTopProducts] = useState<SalesData[]>([]);
  const [recentSales, setRecentSales] = useState<any[]>([]);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    // Fetch total revenue
    const { data: salesData } = await supabase
      .from('sales')
      .select('total_price');
    
    const revenue = salesData?.reduce((acc, curr) => acc + curr.total_price, 0) || 0;
    setTotalRevenue(revenue);

    // Fetch total products
    const { count } = await supabase
      .from('books')
      .select('*', { count: 'exact' });
    
    setTotalProducts(count || 0);

    // Fetch top selling products
    const { data: topSelling } = await supabase
      .from('sales')
      .select(`
        quantity,
        books (
          title,
          price
        )
      `)
      .order('quantity', { ascending: false })
      .limit(5);

    if (topSelling) {
      const formattedData = topSelling.map((sale) => ({
        title: sale.books.title,
        total: sale.quantity,
      }));
      setTopProducts(formattedData);
    }

    // Fetch recent sales
    const { data: recent } = await supabase
      .from('sales')
      .select(`
        *,
        books (
          title
        )
      `)
      .order('created_at', { ascending: false })
      .limit(5);

    setRecentSales(recent || []);
  };

  return (
    <Layout>
      <div className="p-6">
        <h1 className="text-2xl font-bold mb-6">Dashboard</h1>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
          <StatCard
            title="Total Revenue"
            value={`$${totalRevenue.toFixed(2)}`}
            Icon={DollarSign}
            color="bg-blue-100 text-blue-600"
          />
          <StatCard
            title="Total Products"
            value={totalProducts}
            Icon={Package}
            color="bg-green-100 text-green-600"
          />
          <StatCard
            title="Top Selling"
            value={topProducts[0]?.title || 'No data'}
            Icon={TrendingUp}
            color="bg-purple-100 text-purple-600"
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white p-6 rounded-lg shadow">
            <h2 className="text-lg font-bold mb-4">Sales by Product</h2>
            <SalesChart data={topProducts} />
          </div>

          <div className="bg-white p-6 rounded-lg shadow">
            <h2 className="text-lg font-bold mb-4">Recent Sales</h2>
            <RecentSales sales={recentSales} />
          </div>
        </div>
      </div>
    </Layout>
  );
}