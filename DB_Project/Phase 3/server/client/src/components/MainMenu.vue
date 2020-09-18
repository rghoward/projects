<template>
  <div class="container">
    <div class="row">
      <div class="col-sm-10">
        <h1>SEDW Statistics</h1>
        <hr><br><br>
        <br><br>
        <table class="table table-hover">
          <thead>
            <tr>
              <th scope="col">Store Count</th>
              <th scope="col">Active Managers</th>
              <th scope="col">Inactive Managers</th>
              <th scope="col">Products</th>
              <th scope="col">Manufacturers</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
           <tr v-for="(row, index) in results" :key="index">
              <td>{{ row.store_count }}</td>
              <td>{{ row.active_managers }}</td>
              <td>{{ row.inactive_managers }}</td>
              <td>{{ row.products }}</td>
              <td>{{ row.manufacturers }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
/* eslint-disable */
import axios from 'axios';

export default {
  data () {
    return {
      results: []
    };
  },
  methods: {
    getMainMenuStats () {
      const path = 'http://192.168.1.65:8081/main_menu_statistics';
      axios.get(path)
        .then((res) => {
          this.results = res.data.results
          console.log(res)
          let keys = Object.keys(res.data.results)
          console.log(keys)
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        })
    }
  },
  created () {
    this.getMainMenuStats();
  }
};
</script>
