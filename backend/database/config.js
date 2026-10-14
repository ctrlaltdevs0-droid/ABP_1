import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { fileURLToPath } from 'node:url';

// Resolve o arquivo pela localização do módulo, independentemente do terminal.
// Variáveis fornecidas pelo ambiente de execução têm prioridade.
dotenv.config({ path: fileURLToPath(new URL('../.env', import.meta.url)), quiet: true });

const supabaseUrl = process.env.SUPABASE_URL?.trim();
const supabaseKey = process.env.SUPABASE_SECRET_KEY?.trim();

if (!supabaseUrl) {
  throw new Error(
    'SUPABASE_URL não foi definida no arquivo .env'
  );
}

if (!supabaseKey) {
  throw new Error(
    'SUPABASE_SECRET_KEY não foi definida no arquivo .env'
  );
}

const parsedUrl = new URL(supabaseUrl);
if (parsedUrl.pathname !== '/' || parsedUrl.search || parsedUrl.hash) {
  throw new Error('SUPABASE_URL deve conter apenas a URL base do projeto, sem /rest/v1/.');
}

const supabase = createClient(
  supabaseUrl,
  supabaseKey,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false
    },

    db: {
      schema: 'public'
    }
  }
);

export default supabase;
