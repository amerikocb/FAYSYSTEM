//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LibreriaDatos.Fay_System
{
    using System;
    using System.Collections.Generic;
    
    public partial class BodegaInventarioOrdenTrabajo
    {
        public int IdBodegaInventarioOrdenProduccion { get; set; }
        public int IdOrdenTrabajo { get; set; }
        public string Trabajo { get; set; }
        public string PliegoPrisma { get; set; }
        public string Descripcion { get; set; }
        public string Medida { get; set; }
        public string TamañoCorte { get; set; }
        public string Demasia { get; set; }
        public string TotalCorte { get; set; }
        public string Observaciones { get; set; }
        public Nullable<int> IdEstado { get; set; }
    
        public virtual Estado Estado { get; set; }
        public virtual OrdenTrabajo OrdenTrabajo { get; set; }
    }
}
