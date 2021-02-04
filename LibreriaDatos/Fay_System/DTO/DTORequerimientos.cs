using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTORequerimientos
    {
        public int Id { get; set; }
        public DateTime? Fecha { get; set; }
        public string Usuario { get; set; }
        public string EstadoRequerimiento { get; set; }
    }
}
