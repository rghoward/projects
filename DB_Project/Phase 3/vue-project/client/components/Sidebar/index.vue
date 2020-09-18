<template>
    <div id="sidebar" :class="{'open': active}">
    <el-menu theme="light" router>
        <div class="logo-container">
              <img src="/logo.jpg">
        </div>
          <el-menu-item index="/">Dashboard</el-menu-item>
         <el-submenu index="1">
           <template slot="title">
              Main Menu
           </template>
           <el-menu-item-group title="Reports">
             <el-menu-item index="/report1">Report 1</el-menu-item>
             <el-menu-item index="/report2">Report 2</el-menu-item>
             <el-menu-item index="/report3">Report 3</el-menu-item>
             <el-menu-item index="/report4">Report 4</el-menu-item>
             <el-menu-item index="/report5">Report 5</el-menu-item>
             <el-menu-item index="/report6">Report 6</el-menu-item>
             <el-menu-item index="/report7">Report 7</el-menu-item>
           </el-menu-item-group>
           <el-menu-item-group title="Data Warehouse Admin Interface">
             <el-menu-item index="/report1">Load Holidays</el-menu-item>
             <el-menu-item index="/report1">Add Manager</el-menu-item>
             <el-menu-item index="/report1">Add Manager</el-menu-item>
             <el-menu-item index="/report1">Assign Manager</el-menu-item>
             <el-menu-item index="/report1">Unassign Manager</el-menu-item>
             <el-menu-item index="/city">Update City Population</el-menu-item>
           </el-menu-item-group>
         </el-submenu>
         <el-menu-item index="/about">About</el-menu-item>
       </el-menu>
   </div>
</template>

<script>
export default {
  name: 'Sidebar',
  props: ['active'],
  computed () {
      active: () => {
          console.log(this)
          return this.active
      }
  }
}
</script>

<style lang="scss">
// You can import all your SCSS variables using webpack alias
@import '~scss_vars';
@import './style.scss';
</style>
