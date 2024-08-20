// Função para carregar os agendamentos
function fetchags() {
    axios.get('http://Samsung_050420:4466/ag')
        .then(function (response) {
            let ags = response.data;
            // Filtra apenas os agendamentos pendentes
            let pendingAgs = ags.filter(ag => ag.status.toLowerCase() === 'pendente');
            displayags(pendingAgs);
        })
        .catch(function (error) {
            console.error('Erro ao carregar agendamentos:', error);
        });
}

// Função para exibir os agendamentos pendentes na tela
function displayags(ags) {
    let agsContainer = document.getElementById('ags');
    agsContainer.innerHTML = '';

    ags.forEach(function (ag) {
        let agCard = document.createElement('div');
        agCard.classList.add('card');

        let container = document.createElement('div');
        container.classList.add('container');

        let title = document.createElement('h5');
        title.innerText = "ID Agendamento: " + ag.id_agendamento;
        container.appendChild(title);

        let data = document.createElement('p');
        data.innerText = "Data: " + new Date(ag.data_agendamento).toLocaleDateString();
        container.appendChild(data);

        let hora = document.createElement('p');
        hora.innerText = "Horário: " + new Date(ag.horário).toLocaleTimeString();
        container.appendChild(hora);

        let tipoResiduo = document.createElement('p');
        tipoResiduo.innerText = "Tipo de Resíduo: " + ag.tipo_residuo;
        container.appendChild(tipoResiduo);

        let quantidadeResiduo = document.createElement('p');
        quantidadeResiduo.innerText = "Quantidade de Resíduo: " + ag.quantidade_residuo;
        container.appendChild(quantidadeResiduo);

        let usuarioId = document.createElement('p');
        usuarioId.innerText = "ID Usuário: " + ag.usuario_id;
        container.appendChild(usuarioId);

        let status = document.createElement('span');
        status.classList.add('status-pending');
        status.innerText = 'Pendente';
        container.appendChild(status);

        // Adiciona botões de ação
        let actionButtons = document.createElement('div');
        actionButtons.classList.add('action-buttons');

        let acceptButton = document.createElement('button');
        acceptButton.innerText = 'Aceitar';
        acceptButton.onclick = function() {
            acceptAg(ag.id_agendamento);
        };

        actionButtons.appendChild(acceptButton);
        container.appendChild(actionButtons);

        agCard.appendChild(container);
        agsContainer.appendChild(agCard);
    });
}

// Função para aceitar um agendamento usando PUT
function acceptAg(id_agendamento) {
    axios.put(`http://Samsung_050420:4466/ag/${id_agendamento}`, { status: 'Aceito' })
        .then(function (response) {
            alert('Agendamento aceito com sucesso!');
            fetchags(); // Recarregar agendamentos após aceitar
        })
        .catch(function (error) {
            console.error('Erro ao aceitar agendamento:', error);
        });
}

// Carregar agendamentos pendentes ao carregar a página
window.onload = function () {
    fetchags();
}
