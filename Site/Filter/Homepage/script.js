function fetchUsers() {
    axios.get('http://localhost:1212/user')
        .then(function (response) {
            let users = response.data;
            displayUsers(users);
            loadNeighborhoods(users);
        })
        .catch(function (error) {
            console.error('Erro ao carregar usuários:', error);
        });
}
function displayUsers(users) {
    let usersContainer = document.getElementById('users');
    usersContainer.innerHTML = '';

    users.forEach(function (user) {
        let userCard = document.createElement('div');
        userCard.classList.add('user-card');

        let container = document.createElement('div');
        container.classList.add('container');

        let name = document.createElement('h5');
        name.innerText = "Nome: " + user.nome.toUpperCase();
        container.appendChild(name);

        let bairro = document.createElement('p');
        bairro.innerText = "Bairro: " + user.bairro;
        container.appendChild(bairro);

        if (user.cpf) {
            let cpf = document.createElement('p');
            cpf.innerText = "CPF: " + user.cpf;
            container.appendChild(cpf);
        } else if (user.cnpj) {
            let cnpj = document.createElement('p');
            cnpj.innerText = "CNPJ: " + user.cnpj;
            container.appendChild(cnpj);
        }

        if (user.email) {
            let email = document.createElement('p');
            email.innerText = "Email: " + user.email;
            container.appendChild(email);
        }

        if (user.rua && user.num_casa) {
            let address = document.createElement('p');
            address.innerText = "Endereço: " + user.rua + ", Nº " + user.num_casa;
            container.appendChild(address);
        }

        if (user.cep) {
            let cep = document.createElement('p');
            cep.innerText = "CEP: " + user.cep;
            container.appendChild(cep);
        }

        userCard.appendChild(container);
        usersContainer.appendChild(userCard);
    });
}

function loadNeighborhoods(users) {
    let neighborhoods = {};
    let select = document.getElementById('bairro-container');

    users.forEach(function (user) {
        let neighborhood = user.bairro;
        if (neighborhood && !neighborhoods[neighborhood]) {
            neighborhoods[neighborhood] = true;
            createFilterButton(neighborhood);
        }
    });

    let allButton = document.querySelector('.button-value');
    allButton.classList.add('selected');
}

function createFilterButton(neighborhood) {
    let select = document.getElementById('bairro-container');

    let button = document.createElement('button');
    button.classList.add('button-value');
    button.textContent = neighborhood;
    button.onclick = function() {
        filterUsersByNeighborhood(neighborhood);
    };

    select.appendChild(button);
}

function filterUsersByNeighborhood(neighborhood) {
    let userCards = document.getElementsByClassName('user-card');
    let buttons = document.getElementsByClassName('button-value');

    for (let button of buttons) {
        button.classList.remove('selected');
        if (button.textContent === neighborhood) {
            button.classList.add('selected');
        }
    }

    for (let card of userCards) {
        let userNeighborhood = card.querySelector('p').innerText.split(": ")[1];
        
        if (neighborhood === 'todos' || userNeighborhood === neighborhood) {
            card.style.display = "block";
        } else {
            card.style.display = "none";
        }
    }
}

document.getElementById('search').addEventListener('click', function () {
    let searchTerm = document.getElementById('search-input').value.toUpperCase();
    let userCards = document.getElementsByClassName('user-card');

    for (let card of userCards) {
        let nameElement = card.querySelector('h5').innerText.split(": ")[1].toUpperCase();

        if (nameElement.includes(searchTerm)) {
            card.style.display = "block";
        } else {
            card.style.display = "none";
        }
    }

    if (searchTerm === '') {
        for (let card of userCards) {
            card.style.display = "block";
        }
    }

    let allButton = document.querySelector('.button-value');
    allButton.classList.add('selected');

    let buttons = document.querySelectorAll('.button-value');
    buttons.forEach(button => {
        if (button !== allButton) {
            button.classList.remove('selected');
        }
    });
});


window.onload = function () {
    fetchUsers();
}
