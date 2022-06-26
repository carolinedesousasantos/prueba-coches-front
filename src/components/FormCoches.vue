<template>
    <div>
        <v-container>
            <router-link to="/">Volver</router-link>
            <v-card elevation="5">

                <v-card-title>{{ title }}</v-card-title>

                <v-form ref="form" v-model="valid" lazy-validation>
                    <v-container>
                        <v-row>
                            <v-col cols="12" sm="6" md="4">
                                <v-text-field v-model="marca" :rules="textFieldRules" label="Marca" clearable required>
                                </v-text-field>
                            </v-col>

                            <v-col cols="12" sm="6" md="4">
                                <v-text-field v-model="modelo" :rules="textFieldRules" label="Modelo" clearable
                                    required>
                                </v-text-field>
                            </v-col>

                            <v-col cols="12" sm="6" md="4">
                                <v-select v-model="colorSelected" :items="colores" label="Colores" :rules="colorRules"
                                    @change="getSelectedColor($event)">
                                </v-select>
                            </v-col>

                            <v-col cols="12" sm="6" md="4">
                                <v-text-field v-model="cantidad" type="number" min=0 :rules="cantidadRules"
                                    label="Cantidad" required />
                            </v-col>

                            <v-col cols="12" sm="6" md="4">
                                <v-text-field v-model="precio" type="number" min=0 step="0.00" label="Precio" required />
                            </v-col>
                            <v-col cols="12" sm="6" md="4">
                                <v-checkbox v-model="disponible" label="Disponible para venta"></v-checkbox>
                            </v-col>
                        </v-row>

                    </v-container>
                </v-form>
                <v-card-actions>
                    <v-container>
                        <v-row v-if="registrar">
                            <v-btn color="primary" class="mr-4 btn-form" @click="create">
                                Registrar
                            </v-btn>
                        </v-row>

                        <v-row v-else>
                            <v-btn color="primary" class="mr-4 btn-form" @click="updateCar">
                                Actualizar
                            </v-btn>
                        </v-row>
                    </v-container>

                </v-card-actions>
            </v-card>
            <v-alert :value="showAlert" dense text transition="scale-transition" :type="alertType">
                {{ responseMsg }}</v-alert>
        </v-container>
    </div>
</template>

 <style>
 .v-card {
     margin-bottom: 30px;
 }
 
 .btn-form {
     position: absolute;
     right: 20px;
     bottom: 10px;
 }
 </style>

<script>
const axios = require('axios').default;
var backEndHost= process.env.BACKENDHOST || 'http://localhost:8080';
export default {
    name: "FormCoches",
    data() {
        return {
            valid: true,
            registrar: true,
            title: "Información del coche",
            responseMsg: "",
            showAlert: false,
            alertType: "success",
            marca: '',
            modelo: '',
            disponible: true,
            cantidad: 0,
            precio: 0,
            colores: [],
            colorSelected: "",
            colorRules: [
                v => v && !!v.trim() || 'El campo color no puede estar vazio',
            ],
            textFieldRules: [
                v => v.length >= 3 || 'El campo debe tener 3 o caracteres',
            ],
            cantidadRules: [
                v => (v && v > 0) || "Cantidad no puede ser 0",
                v => (v && v <= 1000) || "Cantidad no debe exceder 1000",
            ],
            precioRules: [
                v => Number.isInteger(!Number(v)) || "El formato del precio no está correcto",
            ],
            idParam: 0,
        }
    },
    methods: {
        create() {
            if (this.$refs.form.validate()) {
                var self = this;
                var data = {
                    marca: this.marca,
                    modelo: this.modelo,
                    cantidad: parseInt(this.cantidad),
                    precio: this.precio,
                    disponible: this.disponible,
                    color: this.colorSelected
                };
            
  
                axios({
                    method: 'post',
                    url: `${backEndHost}/cars`,
                    responseType: 'application/json',
                    data: data
                })
                    .then(function (response) {
                        self.coches = response.data;
                        if (response.status == 201) {
                            self.alertType = "success";
                            self.showAlert = true;
                            self.responseMsg = "Coche registrado con éxito";                        
                            self.$refs.form.resetValidation()               
                            self.$refs.form.reset();
                        }
                    }).catch(function (error) {
                        self.showAlert = true;
                        self.alertType = "error";
                        self.responseMsg = error;
                    });
            }
        },
        getSelectedColor(event) {
            this.colorSelected = event;
        },
        updateCar() {
            if (this.$refs.form.validate()) {
                var id = this.idParam;
                var self = this;
                var data = {
                    marca: this.marca,
                    modelo: this.modelo,
                    cantidad: parseInt(this.cantidad),
                    precio: this.precio,
                    disponible: this.disponible,
                    color: this.colorSelected
                };
                axios({
                    method: 'put',
                    url: `${backEndHost}/cars/${id}`,
                    responseType: 'application/json',
                    data: data
                })
                    .then(function (response) {
                        self.coches = response.data;
                        if (response.status == 200) {

                            self.showAlert = true;
                            self.responseMsg = "Coche actualizado con éxito";
                        }
                    }).catch(function (error) {
                        self.showAlert = true;
                        self.alertType = "error";
                        self.responseMsg = error;
                    })
                    .finally(function() {
                        setTimeout(() => {
                        self.$router.push("/")
                        }, 1000);
                    });
            }
        },
        getCar(id) {
            var self = this;
            axios({
                method: 'get',
                url: `${backEndHost}/cars/${id}`,
                responseType: 'application/json'
            })
                .then(function (response) {
                    var car = response.data;
                    console.log(car);
                    self.marca = car.marca;
                    self.modelo = car.modelo;
                    self.disponible = car.disponible;
                    self.cantidad = car.cantidad;
                    self.colorSelected = car.color;
                    self.precio = car.precio;

                    if (!response.status == 200) {
                        self.showAlert = true;
                        this.alertType = "error"
                        self.responseMsg = "error";
                    }
                });
        },
        getColors() {
            var self = this;
            axios({
                method: 'get',
                url: `${backEndHost}/colors`,
                responseType: 'application/json'
            })
                .then(function (response) {
                    self.colores = response.data;
                });
        }

    },
    mounted: function () {
        this.getColors();
        var urlParmId = this.$route.params.id;
        if (urlParmId) {
            this.registrar = false;
            this.getCar(urlParmId);
            this.idParam = urlParmId;
        } else {
            this.registrar = true;
        }
    },
}
</script>