<template>
  <div class="hello">
    <div class="container">
      <div class="row">
        <div class="col-sm-10">
          <h1>Report 1</h1>
          <hr>
          <!-- Add below line of code for row click events   
	@row-click="handle" 

    Line below is for alternating row coloring
    :row-class-name="tableRowClassName"
          -->
          <el-table
            ref="multipleTable"
            :data="results"
            stripe
            :default-sort="{prop: 'ID', order: 'descending'}"
            style="width: 100%"
            max-height="1050"
            max-width="1250"
          >
            <el-table-column fixed prop="id" label="ID" sortable></el-table-column>
            <el-table-column prop="name" label="Manufacturer" sortable width="180"></el-table-column>
            <el-table-column prop="total_products" label="Products" sortable></el-table-column>
            <el-table-column label="Avg Retail" sortable>
              <p slot-scope="{row}">${{row.avg_retail_price}}</p>
            </el-table-column>
            <el-table-column label="Min Retail" sortable>
              <p slot-scope="{row}">${{row.min_retail_price}}</p>
            </el-table-column>
            <el-table-column label="Max Retail" sortable>
              <p slot-scope="{row}">${{row.max_retail_price}}</p>
            </el-table-column>
            <el-table-column fixed="right" label="Operations" width="120">
              <template scope="scope">
                <el-button
                  @click="handleClick(scope.$index,results)"
                  type="text"
                  size="small"
                >Detail</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
.el-table .info-row {
  background: #c9e5f5;
}

.el-table .positive-row {
  background: #e2f0e4;
}
</style>

<script>
import axios from "axios";

export default {
  name: "Report1",
  data() {
    return {
      results: []
    };
  },
  computed: {
    postId() {
      return this.$route.params.id;
    }
  },
  methods: {
    getProducts() {
      const path = "http://localhost:5000/report1";
      axios
        .get(path)
        .then(res => {
          this.results = res.data.results;
        })
        .catch(error => {
          // eslint-disable-next-lineI
          console.error(error);
        });
    },
    tableRowClassName(row, index) {
      if (index % 2 == 0) {
        return "info-row";
      } else {
        return "positive-row";
      }
      return "";
    },
    handleClick(index, results) {
      console.log("click" + index + "Manufactuer ID:" + results[index].id);
      window.open(
        "http://localhost:4000/report1/" + results[index].id,
        results[index].name,
        "height=500,width=700,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes"
      );
    },
    handle(row, event, column) {
      //   console.log(row, event, column)
      this.$alert("This is a message" + row.id, row.name, {
        confirmButtonText: "OK"
        /*callback: action => {
            this.$message({
              type: 'info',
              message: `action: ${ action }`
            });
          }*/
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
