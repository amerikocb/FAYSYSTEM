using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOAjusteInventario
    {
        public int Id { get; set; }
        public string Almacen { get; set; }
        public DateTime? Fecha { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
    }
}
