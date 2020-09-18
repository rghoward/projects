<template>
  <div class="hello">
    <div class="container">
      <div class="row">
        <div class="col-sm-10">
          <h1>Report 5</h1>
          <hr>

          <el-table
            ref="multipleTable"
            :data="results"
            stripe
            style="width: 100%"
            :row-class-name="tableRowClassName"
            max-height="1050"
            max-width="1250"
          >
            <el-table-column fixed prop="year" label="Year" sortable></el-table-column>
            <el-table-column prop="sales" label="Total Sales This Year" sortable></el-table-column>
            <el-table-column prop="daily_sales" label="Daily Sales" sortable></el-table-column>
            <el-table-column prop="groundhogday_sales" label="GroundHog Day Sales" sortable></el-table-column>
          </el-table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Report5",
  data() {
    return {
      results: []
    };
  },
  methods: {
    getProducts() {
      const path = "http://localhost:5000/report5";
      axios
        .get(path)
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
    this.getProducts();
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
