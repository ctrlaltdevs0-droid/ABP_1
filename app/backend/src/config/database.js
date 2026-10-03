import pg from "pg";

const pool = new pg.Pool({
    port: 5432,
    database: "postgres",
    user: "postgres",
    password: "123"
});

export default pool;
