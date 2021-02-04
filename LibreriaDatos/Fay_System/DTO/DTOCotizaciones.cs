using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOCotizaciones
    {
        public int Id { get; set; }
        public DateTime? Fecha { get; set; }
        public string Usuario { get; set; }
        public string EstadoCotizacion { get; set; }
        public int? IdClienteNatural { get; set; }
        public int? IdClienteJuridico { get; set; }
        public string RazonSocialEmpresa { get; set; }
        public string ApelNomCliente { get; set; }
    }
}
