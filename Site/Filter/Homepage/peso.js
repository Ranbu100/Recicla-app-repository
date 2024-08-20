function converterParaKg(quantidade, unidade) {
    switch (unidade) {
        case 'g':
            return quantidade / 1000;
        case 'mg':
            return quantidade / 1000000;
        case 'ton':
            return quantidade * 1000;
        default:
            return quantidade;
    }
}

function enviarDados() {
    const tipoResiduo = document.getElementById('tipo-residuo').value;
    const dataResiduo = document.getElementById('data-residuo').value;
    const quantidadeResiduo = parseFloat(document.getElementById('quantidade-residuo').value);
    const unidadeResiduo = document.getElementById('unidade-residuo').value;

    if (!tipoResiduo) {
        alert('Por favor, selecione o tipo de resíduo.');
        return;
    }

    if (!dataResiduo) {
        alert('Por favor, selecione a data.');
        return;
    }

    if (isNaN(quantidadeResiduo) || quantidadeResiduo <= 0) {
        alert('Por favor, insira uma quantidade válida de resíduos.');
        return;
    }

    const quantidadeKg = converterParaKg(quantidadeResiduo, unidadeResiduo);

    const dados = {
        tipo_residuo: tipoResiduo,
        data_residuo: dataResiduo,
        quantidade_residuo: quantidadeKg
    };

    fetch('http://Samsung_050420:4466/peso', {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(dados)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Erro ao enviar os dados.');
        }
        return response.json();
    })
    .then(data => {
        alert('Dados enviados com sucesso!');
        // Limpar formulário após envio bem sucedido (opcional)
        document.getElementById('tipo-residuo').value = '';
        document.getElementById('data-residuo').value = '';
        document.getElementById('quantidade-residuo').value = '';
        document.getElementById('unidade-residuo').value = 'kg';
    })
    .catch(error => {
        console.error('Erro ao enviar dados:', error);
        alert('Ocorreu um erro ao enviar os dados. Por favor, tente novamente.');
    });
}
