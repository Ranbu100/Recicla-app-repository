const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 4466;

// Configuração do Multer para salvar imagens no diretório 'uploads'
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = path.join(__dirname, 'public', 'uploads');
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage });

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rota PUT para atualizar a URL da imagem no sistema
app.put('/news/image', (req, res) => {
  const { id } = req.params;
  const { url, manchete, descricao, noticia_id } = req.body;

  // Aqui você deve adicionar a lógica para atualizar a imagem com o ID fornecido.
  // Para simplificação, estamos apenas respondendo com os dados recebidos.
  res.json({
    message: 'Dados atualizados com sucesso!',
    data: { id, url, manchete, descricao, noticia_id }
  });
});

app.use('/uploads', express.static(path.join(__dirname, 'public', 'uploads')));

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
