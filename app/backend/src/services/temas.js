import pool from "../config/database.js";

async function listarTemasService(){
    const {rows} = await pool.query("SELECT * FROM temas ORDER BY ordem");
    return rows;
}

export default listarTemasService;
