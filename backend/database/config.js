import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SECRET_KEY;

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