import React, { useEffect, useState } from 'react';
import { DollarSign, Package, TrendingUp } from 'lucide-react';
import { salesApi } from '../lib/api';
import Layout from '../components/Layout';
import StatCard from '../components/dashboard/StatCard';
import SalesChart from '../components/dashboard/SalesChart';
import RecentSales from '../components/dashboard/RecentSales';

interface DadosDashboard {
  receitaTotal: number;
  totalProdutos: number;
  produtoMaisVendido: string;
  vendasPorProduto: Array<{
    titulo: string;
    total: number;
  }>;
}

export default function Dashboard() {
  const [dados, setDados] = useState<DadosDashboard | null>(null);
  const [vendasRecentes, setVendasRecentes] = useState([]);

  useEffect(() => {
    buscarDadosDashboard();
  }, []);

  const buscarDadosDashboard = async () => {
    try {
      const [estatisticas, vendas] = await Promise.all([
        salesApi.getEstatisticas(),
        salesApi.getVendasRecentes()
      ]);
      
      setDados(estatisticas);
      setVendasRecentes(vendas);
    } catch (erro) {
      console.error('Erro ao buscar dados do dashboard:', erro);
    }
  };

  if (!dados) {
    return <Layout>Carregando...</Layout>;
  }

  return (
    <Layout>
      <div className="p-6">
        <h1 className="text-2xl font-bold mb-6">Painel de Controle</h1>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
          <StatCard
            title="Receita Total"
            value={`R$ ${dados.receitaTotal.toFixed(2)}`}
            Icon={DollarSign}
            color="bg-blue-100 text-blue-600"
          />
          <StatCard
            title="Total de Produtos"
            value={dados.totalProdutos}
            Icon={Package}
            color="bg-green-100 text-green-600"
          />
          <StatCard
            title="Mais Vendido"
            value={dados.produtoMaisVendido}
            Icon={TrendingUp}
            color="bg-purple-100 text-purple-600"
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white p-6 rounded-lg shadow">
            <h2 className="text-lg font-bold mb-4">Vendas por Produto</h2>
            <SalesChart data={dados.vendasPorProduto} />
          </div>

          <div className="bg-white p-6 rounded-lg shadow">
            <h2 className="text-lg font-bold mb-4">Vendas Recentes</h2>
            <RecentSales sales={vendasRecentes} />
          </div>
        </div>
      </div>
    </Layout>
  );
}