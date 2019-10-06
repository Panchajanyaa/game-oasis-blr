<template>
  <div class="">
    <b-button @click="addTournament()">Add Tournament</b-button>
    <b-button @click="getTournamentId()">Get ID</b-button>

    <b-field label="Message">
      <b-input v-modal='playerArray' type="textarea"></b-input>
    </b-field>

    <b-button @click='addPlayers()'>Add Players </b-button>

    <b-button @click='settle()'>Settle</b-button>
  </div>
</template>

<script>
  import Web3 from 'web3';

  import config from '~/configs/config'
  import BettingContractABI from '~/configs/contracts/BettingContractABI.js'
  import StandardERC20TokenABI from '~/configs/contracts/StandardERC20TokenABI.js'

  export default {
    data() {
      return {
        playerArray: ['0xf8454a749418e5e8c6a116900b10c4b7c2573349', '0x7C27C62376f85797288b4Cc2B5b924d2FE70a462']
      }
    },

    methods: {
      async connectMetamask() {
        if (window.ethereum) {
          window.web3 = new Web3(ethereum);
          //this.updateAccount()
          try {
            await ethereum.enable();
          } catch (error) {
            console.log(error)
          }
        } else if (window.web3) {
          window.web3 = new Web3(web3.currentProvider);
        } else {
          alert('Please use Web3 Enabled Device')
        }
      },

      async addTournament() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        await contract.methods.addTournament().send({
            from: web3.currentProvider.selectedAddress
          })
          .then(Response => console.log(Response))
          .catch(err => console.log(err))
      },

      async getTournamentId() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        const tournamentId = await contract.methods.getTournamentId().call()
        console.log(tournamentId)
      },

      async addPlayers() {
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        await contract.methods.addParticipants(this.playerArray, 101).send({
            from: web3.currentProvider.selectedAddress
          })
          .then(Response => console.log(Response))
          .catch(err => console.log(err))
      },

      async settle(){
        const contract = new web3.eth.Contract(BettingContractABI, config.MATIC_BETTING_CONTRACT_ADDRESS)
        await contract.methods.settle('101', '0xf8454a749418e5e8c6a116900b10c4b7c2573349').send({
            from: web3.currentProvider.selectedAddress
          })
          .then(Response => console.log(Response))
          .catch(err => console.log(err))
      }
    },

    created() {
      this.connectMetamask()
    }

  }

</script>
