using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOEmpleado
    {
        public int Id { get; set; }
        public string NombreCompleto { get; set; }
        public string Nombres { get; set; }
        public string ApPaterno { get; set; }
        public string ApMaterno { get; set; }
        public DateTime? FechaNacimiento { get; set; }
        public int IdCargo { get; set; }
        public string Cargo { get; set; }
        public string DNI { get; set; }
        public string RUC { get; set; }
        public int IdProfesion { get; set; }
        public string Profesion { get; set; }
        public string Estado { get; set; }
        public int IdEstado { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public string Sexo { get; set; }

    }
    
}
