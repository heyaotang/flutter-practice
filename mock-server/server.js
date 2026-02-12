import Fastify from 'fastify';
import cors from '@fastify/cors';
import staticPlugin from '@fastify/static';
import path from 'path';
import { fileURLToPath } from 'url';
import { existsSync, createReadStream } from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Constants
const SERVER_CONFIG = {
  port: 3000,
  host: 'localhost',
};

const API_RESPONSES = {
  success: { code: '0', message: 'success' },
  error: { code: '-1', message: 'error' },
};

const MOCK_DATA = {
  banners: [
    { id: '1', image: 'http://localhost:3000/assets/images/banners/banner1.jpg' },
    { id: '2', image: 'http://localhost:3000/assets/images/banners/banner2.jpg' },
    { id: '3', image: 'http://localhost:3000/assets/images/banners/banner3.jpg' },
    { id: '4', image: 'http://localhost:3000/assets/images/banners/banner4.jpg' },
    { id: '5', image: 'http://localhost:3000/assets/images/banners/banner5.jpg' },
  ],
};

// Product constants
const TOTAL_PRODUCTS = 102;

// UUID v4 generator
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// Generate a single product
function generateProduct(index) {
  return {
    id: generateUUID(),
    name: `Product ${index + 1}`,
    image: `http://localhost:3000/assets/images/products/product.jpg`,
    price: parseFloat(((index + 1) * 10 + Math.random() * 100).toFixed(2)),
  };
}

// Create Fastify instance
const fastify = Fastify({
  logger: true,
});

// Response helpers
function createSuccessResponse(data) {
  return {
    ...API_RESPONSES.success,
    data,
  };
}

function createErrorResponse(message) {
  return {
    ...API_RESPONSES.error,
    message,
  };
}

// Register plugins
await fastify.register(cors, {
  origin: true,
});

// Set error handler
fastify.setErrorHandler((error, request, reply) => {
  fastify.log.error(error);
  reply.code(500).send(createErrorResponse('Internal server error'));
});

// Health check endpoint
fastify.get('/', async (request, reply) => {
  return createSuccessResponse({ status: 'ok', timestamp: Date.now() });
});

// Get banners endpoint
fastify.post('/get-banners', async (request, reply) => {
  try {
    return createSuccessResponse(MOCK_DATA.banners);
  } catch (error) {
    fastify.log.error('Error fetching banners:', error);
    return reply.code(500).send(createErrorResponse('Failed to fetch banners'));
  }
});

// Get products endpoint with pagination
fastify.post('/get-products', async (request, reply) => {
  try {
    const { offset = 0, limit = 20 } = request.body || {};

    const start = Math.max(0, parseInt(offset) || 0);
    const pageSize = parseInt(limit) || 20;
    const end = Math.min(start + pageSize, TOTAL_PRODUCTS);

    // If offset is beyond total products, return empty array
    if (start >= TOTAL_PRODUCTS) {
      return createSuccessResponse({
        products: [],
        total: TOTAL_PRODUCTS,
        hasMore: false,
      });
    }

    // Generate products for this page
    const products = [];
    for (let i = start; i < end; i++) {
      products.push(generateProduct(i));
    }

    const hasMore = end < TOTAL_PRODUCTS;

    return createSuccessResponse({
      products,
      total: TOTAL_PRODUCTS,
      hasMore,
    });
  } catch (error) {
    fastify.log.error('Error fetching products:', error);
    return reply.code(500).send(createErrorResponse('Failed to fetch products'));
  }
});

fastify.post('/login', async (request, reply) => {
  try {
    const { username = '', password = '' } = request.body || {};
    if (!username || !password) {
      return createErrorResponse('Missing username or password');
    }
    if ('username' !== username || 'password' !== password) {
      return createErrorResponse('Username or password is incorrect');
    }
    return createSuccessResponse({
      tokenType: 'Bearer',
      accessToken: generateUUID(),
      refreshToken: generateUUID(),
      expiresIn: 3600,
    });
  } catch (error) {
    fastify.log.error('Error logging in:', error);
    return reply.code(500).send(createErrorResponse('Failed to login'));
  }
})

fastify.post('/logout', async (request, reply) => {
  return createSuccessResponse({});
})

fastify.post('/profile', async (request, reply) => {
  try {
    const auth = request.headers.authorization;
    if (!auth) {
      return reply.code(401).send(createErrorResponse('Unauthorized'));
    }
    return createSuccessResponse({
      username: 'username',
      avatar: 'http://localhost:3000/assets/images/avatar/user.png',
    });
  } catch (error) {
    fastify.log.error('Error fetching profile:', error);
    return reply.code(500).send(createErrorResponse('Failed to fetch profile'));
  }
})

// Start server
try {
  await fastify.register(staticPlugin, {
    root: `${process.cwd()}/assets`,
    prefix: '/assets/'
  });
  await fastify.listen({ port: SERVER_CONFIG.port, host: SERVER_CONFIG.host });
  console.log(`Mock server running at http://${SERVER_CONFIG.host}:${SERVER_CONFIG.port}`);
} catch (err) {
  fastify.log.error(err);
  process.exit(1);
}
