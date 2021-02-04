using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOOrdenesTrabajo
    {
        public int Id { get; set; }
        public int IdOrdenVenta { get; set; }
        public string Trabajo { get; set; }
        public DateTime? FechaEmision { get; set; }
        public DateTime? FechaEntregaO { get; set; }
        public DateTime? FechaEntregaF { get; set; }
        public string Estado { get; set; }
        public int IdEjecutivo { get; set; }
        public string DatosEjecutivo { get; set; }
        public int IdCliente { get; set; }
        public string DatosCliente { get; set; }
        public int NumeroSelecciones { get; set; }
        public int NumeroPlacasUnColor { get; set; }
        public int TotalPlacas { get; set; }
        public int NumeroOrdenado { get; set; }
        public string Maquina { get; set; }
        public int PagPortada { get; set; }
        public int PaginaInteriores { get; set; }
        public string TamañoAbierto { get; set; }
        public bool FullColor { get; set; }
        public string colores { get; set; }
        public string IColor { get; set; }
        public string Liniaje { get; set; }
        public bool Panelse { get; set; }
        public string Observaciones { get; set; }
        public bool Ctp { get; set; }
        public bool Canson { get; set; }
        public int IdEstado { get; set; }
    }
}
