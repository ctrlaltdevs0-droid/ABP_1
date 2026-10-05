import pool from "../config/database.js";

async function listarTemas(){
    const {rows} = await pool.query("SELECT * FROM temas ORDER BY ordem");
    return rows;
}

export default listarTemas;
