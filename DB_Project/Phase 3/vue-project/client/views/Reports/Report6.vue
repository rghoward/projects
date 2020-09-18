<template>
  <div class="container">
    <div class="col-sm-10">
      <h1>Report 6</h1>
      <hr>

      <br>
      <form>
        Please choose a month and year to run the report:
        <select
          v-bind="getDates"
          v-model="selected"
          id="mySelect"
        >
          <option
            v-for="(row, index) in dates"
            :key="index"
            :value="row.date"
            v-bind="dates"
          >{{row.date}}</option>
        </select>
      </form>
      <button type="button" v-on:click="printMessage">Try it</button>
    </div>
    <br>
    <el-table
      ref="multipleTable"
      :data="results"
      stripe
      style="width: 100%"
      :row-class-name="tableRowClassName"
      max-height="1050"
      max-width="1250"
    >
      <el-table-column fixed prop="category" label="Category Name" sortable></el-table-column>
      <el-table-column prop="state_name" label="State with Highest Sales" sortable></el-table-column>
      <el-table-column prop="units_sold" label="Number of Units Sold in State" sortable></el-table-column>
    </el-table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Report6",
  data() {
    return {
      message: "Hi",
      results: [],
      dates: []
    };
  },
  methods: {
    printMessage: function() {
      var x = document.getElementById("mySelect").value;
      const payload = x;
      this.getTableData(payload);
    },

    getDates() {
      const path = "http://localhost:5000/report6_dates";
      axios
        .get(path)
        .then(res => {
          this.dates = res.data.results;
        })
        .catch(error => {
          // eslint-disable-next-lineI
          console.error(error);
        });
    },
    getTableData(payload) {
      const path = "http://localhost:5000/report6";
      axios
        .get(path, {
          params: {
            id: payload
          }
        })
        .then(res => {
          this.results = res.data.results;
        })
        .catch(error => {
          // eslint-disable-next-lineI
          console.error(error);
        });
    }
  },
  created() {
    this.getDates();
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
table,
th,
td {
  border: 1px solid black;
  border-collapse: collapse;
  padding: 15px;
}
table {
  border-spacing: 5px;
}
</style>
