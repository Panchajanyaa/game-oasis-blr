<template>
  <section class="section">
    <div class="columns is-mobile">
      <div id="axies">
        <div>
          <table class="table">
            <thead>
              <tr>
                <th><abbr title="rank">Rank</abbr></th>
                <th>Address</th>
                <th><abbr title="name">Name</abbr></th>
                <th><abbr title="rating">Rating</abbr></th>
                <th><abbr title="wins">Wins</abbr></th>
                <th><abbr title="draws">Draws</abbr></th>
                <th><abbr title="losses">Losses</abbr></th>
                <th><button title="Invest">Invest</button></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(leader, index) in leaderboard" :key=index>
                <th>{{ leader.rank }}</th>
                <td><button @click="openInfoModal(leader.address)" class="tag is-light">{{ leader.address }}</button></td>
                <td>{{ leader.name }}</td>
                <td>{{ leader.rating }}</td>
                <td>{{ leader.wins }}</td>
                <td>{{ leader.draws }}</td>
                <td>{{ leader.losses }}</td>
                <td><button class="button is-warning" @click="openInvestModal(leader.address)">Bet</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <!-- bet modal -->
      <div class="modal" id="investModal">
        <div class="modal-background"></div>
        <div class="modal-card">
          <section class="modal-card-body">
            <div class="fie ld">
              <label class="label">How much DAI do you want to invest?</label>
              <div class="control">
                  <input class="input" type="number" placeholder="XX DAI" value="0">
              </div>
            </div>
          </section>
          <footer class="modal-card-foot">
            <button class="button is-success">Save changes</button>
            <button class="button">Cancel</button>
          </footer>
        </div>
        <button class="modal-close is-large" aria-label="close" @click="closeInvestModal"></button>
      </div>
      <!-- end bet modal -->

      <!-- info modal -->
      <div class="modal" id="infoModal">
        <div class="modal-background"></div>
        <div class="modal-card">
          <header class="modal-card-head">
            <p class="modal-card-title">Team info</p>
            <button class="delete" aria-label="close" @click="closeInfoModal()"></button>
          </header>
          <section class="modal-card-body">
            <table class="table">
            <thead>
              <tr>
                <th><abbr title="name">Name of Axie</abbr></th>
                <th>birthDate</th>
                <th>matronClass</th>
                <th><abbr title="name">Picture</abbr></th>
              </tr>
            </thead>
            <tr v-for="(axie, index) in this.specificLeaderAxies" :key="index">
                <th>{{ axie.name }}</th>
                <td>{{ axie.birthDate }}</td>
                <td>{{ axie.matronClass }}</td>
                <img :src=axie.image alt="axie image" width="150px">
              </tr>
              </table>
          </section>
        </div>
      </div>
      <!-- info modal end -->
    </div>
  </section>
</template>

<script>
import Card from "~/components/Card";
import axios from "axios";

export default {
  name: "Buy",

  data() {
    return {
      axies: [],
      leaderboard: [],
      specificLeaderAxies: []
    };
  },

  async mounted() {
    // const axies = await axios.get(`https://axieinfinity.com/api/v2/axies`);
    // console.log(axies.data.axies);
    // this.axies = axies.data.axies;

    // const mockResponseFromSmartContract = [
    //   '97880', '97879', '97877', '97876', '97875', '97874'
    // ];

    // const allAxiesData = await Promise.all(mockResponseFromSmartContract.map(axieId => {
    //   return axios.get(`https://axieinfinity.com/api/v2/axies/${axieId}`);
    // }));

    const leaderboardData = await axios.get(
      `https://api.axieinfinity.com/v1/battle/history/leaderboard`
    );
    console.log(leaderboardData);
    this.leaderboard = leaderboardData.data;
  },

  methods: {
    openInvestModal(leaderAddress) {
      document.querySelector('#investModal').classList.add('is-active');
    },
    closeInvestModal() {
      document.querySelector('#investModal').classList.remove('is-active');
    },
    async openInfoModal(leaderAddress) {
      document.querySelector('#infoModal').classList.add('is-active');
      const allAxiesForLeader = await axios.get(`https://axieinfinity.com/api/v2/addresses/${leaderAddress}/axies`);
      this.specificLeaderAxies = allAxiesForLeader.data.axies;
      console.log(this.specificLeaderAxies);
    },
    closeInfoModal() {
      document.querySelector('#infoModal').classList.remove('is-active');
      this.specificLeaderAxies = [];
    }
  },

  components: {
    Card
  }
};
</script>
