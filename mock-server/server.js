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
