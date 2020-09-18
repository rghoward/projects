<template>
  <div class="hello">
    <div class="container">
      <div class="row">
        <div class="col-sm-10">
          <h1>Report 3</h1>
          <hr>
          <el-table
            ref="multipleTable"
            :data="results"
            style="width: 100%"
            stripe
            :row-class-name="tableRowClassName"
            max-height="1050"
            max-width="1250"
          >
            <el-table-column fixed label="Actual Revenue" sortable>
              <p slot-scope="{row}">${{row.actual_revenue}}</p>
            </el-table-column>
            <el-table-column prop="difference" label="Difference" sortable ></el-table-column>
            <el-table-column prop="name" label="Name" sortable></el-table-column>
            <el-table-column prop="pid" label="PID" sortable></el-table-column>
            <el-table-column label="Predicted Revenue" sortable>
              <p slot-scope="{row}">${{row.predicted_revenue}}</p>
            </el-table-column>
            <el-table-column label="Retail Price" sortable>
              <p slot-scope="{row}">${{row.retail_price}}</p>
            </el-table-column>
            <el-table-column prop="total_units_sold" label="Total Units Sold" sortable></el-table-column>
            <el-table-column prop="units_sold_at_discount" label="Units Sold at Discount" sortable></el-table-column>
            <el-table-column
              prop="units_sold_at_retail_price"
              label="Units Sold at Retail Price"
              sortable
            ></el-table-column>
          </el-table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Report3",
  data() {
    return {
      results: []
    };
  },
  methods: {
    getProducts() {
      const path = "http://localhost:5000/report3";
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
</style>
