import PDFDocument from 'pdfkit';
import QRCode from 'qrcode';

// PDF gerado sob demanda com dados conferidos no banco, sem guardar CPF no PDF.
export async function enviarCertificadoPdf(res, certificado, nomeUsuario) {
  const base = process.env.PUBLIC_BASE_URL?.replace(/\/$/, '');
  if (!base || !/^https?:\/\//.test(base)) throw new Error('Defina PUBLIC_BASE_URL no backend.');
  const urlValidacao = `${base}/api/certificados/validar/${certificado.codigo_validacao}`;
  const qr = await QRCode.toBuffer(urlValidacao, { type: 'png', width: 260, margin: 1 });

  const pdf = new PDFDocument({ size: 'A4', margin: 55, info: { Title: 'Certificado ÁgilCert', Author: 'ÁgilCert' } });
  res.statusCode = 200;
  res.setHeader('Content-Type', 'application/pdf');
  res.setHeader('Content-Disposition', `attachment; filename="agilcert-${certificado.idcertificados}.pdf"`);
  res.setHeader('Cache-Control', 'private, no-store');
  pdf.pipe(res);
  pdf.fontSize(30).text('ÁgilCert', { align: 'center' }).moveDown(1.5);
  pdf.fontSize(24).text('CERTIFICADO DE APROVAÇÃO', { align: 'center' }).moveDown(2);
  pdf.fontSize(15).text('Certificamos que', { align: 'center' }).moveDown(0.6);
  pdf.fontSize(22).text(nomeUsuario, { align: 'center' }).moveDown(1);
  pdf.fontSize(14).text('concluiu com aprovação a avaliação de certificação.', { align: 'center' }).moveDown(1);
  pdf.text(`Aproveitamento: ${Number(certificado.percentual).toFixed(2)}%`, { align: 'center' });
  pdf.text(`Acertos: ${certificado.score} de 12`, { align: 'center' });
  pdf.text(`Emissão: ${new Date(certificado.emitido_em).toLocaleDateString('pt-BR', { timeZone: 'UTC' })}`, { align: 'center' });
  pdf.moveDown(2).fontSize(10).text(`Código de validação: ${certificado.codigo_validacao}`, { align: 'center' });
  const qrX = (pdf.page.width - 110) / 2;
  pdf.image(qr, qrX, pdf.y + 12, { width: 110 });
  pdf.end();
}
