const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Rota raiz
app.get('/', (req, res) => {
  res.send('API Gimie rodando! Acesse /links para ver os produtos.');
});

// GET /links - Retorna lista de produtos (mockado por enquanto)
app.get('/links', (req, res) => {
  // Se houver parâmetro url, processa (futuro)
  const { url } = req.query;
  
  // Por enquanto retorna dados mockados
  const mockData = [
    {
      nome: "Tênis Nike",
      preco: "R$ 399,90",
      imagem: "https://exemplo.com/tenis.jpg",
      url: "https://nike.com/tenis"
    }
  ];
  
  res.json(mockData);
});

// POST /links - Processa URL e retorna dados do produto
app.post('/links', async (req, res) => {
  try {
    const { url } = req.body;
    
    if (!url) {
      return res.status(400).json({ 
        error: 'URL é obrigatória',
        message: 'Por favor, envie uma URL no body da requisição'
      });
    }
    
    // Validar se é uma URL válida
    try {
      new URL(url);
    } catch (e) {
      return res.status(400).json({ 
        error: 'URL inválida',
        message: 'A URL fornecida não é válida'
      });
    }
    
    // Buscar dados do produto
    const productData = await scrapeProductData(url);
    
    if (!productData) {
      return res.status(404).json({ 
        error: 'Produto não encontrado',
        message: 'Não foi possível extrair dados desta URL'
      });
    }
    
    res.json(productData);
    
  } catch (error) {
    console.error('Erro ao processar link:', error);
    res.status(500).json({ 
      error: 'Erro interno',
      message: error.message 
    });
  }
});

// Função para fazer scraping dos dados do produto
async function scrapeProductData(url) {
  try {
    // Fazer requisição HTTP para a URL
    const response = await axios.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
      },
      timeout: 10000
    });
    
    const html = response.data;
    const $ = cheerio.load(html);
    
    // Extrair dados - adaptar seletores conforme o site
    let nome = '';
    let preco = '';
    let imagem = '';
    
    // Tentar diferentes seletores comuns
    // Amazon
    if (url.includes('amazon')) {
      nome = $('#productTitle').text().trim() || 
             $('h1.a-size-large').text().trim();
      
      preco = $('.a-price .a-offscreen').first().text().trim() || 
              $('.a-price-whole').first().text().trim() ||
              $('#priceblock_ourprice').text().trim();
      
      imagem = $('#landingImage').attr('src') || 
               $('.a-dynamic-image').first().attr('src');
    }
    // Mercado Livre
    else if (url.includes('mercadolivre') || url.includes('mercadolibre')) {
      nome = $('h1.ui-pdp-title').text().trim();
      preco = $('.andes-money-amount__fraction').first().text().trim();
      imagem = $('.ui-pdp-image').first().attr('src');
    }
    // Genérico - OpenGraph tags
    else {
      nome = $('meta[property="og:title"]').attr('content') ||
             $('meta[name="title"]').attr('content') ||
             $('h1').first().text().trim();
      
      preco = $('meta[property="og:price:amount"]').attr('content') ||
              $('[itemprop="price"]').attr('content') ||
              $('.price').first().text().trim();
      
      imagem = $('meta[property="og:image"]').attr('content') ||
               $('img[itemprop="image"]').attr('src') ||
               $('img').first().attr('src');
    }
    
    // Limpar e formatar dados
    nome = nome.trim();
    preco = preco.replace(/[^\d,.\s]/g, '').trim();
    
    // Retornar dados estruturados
    return {
      nome: nome || 'Produto',
      preco: preco || '0,00',
      imagem: imagem || '',
      url: url
    };
    
  } catch (error) {
    console.error('Erro no scraping:', error);
    
    // Em caso de erro, retornar dados básicos
    return {
      nome: 'Produto',
      preco: '0,00',
      imagem: '',
      url: url
    };
  }
}

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`API Gimie rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
});

module.exports = app;
