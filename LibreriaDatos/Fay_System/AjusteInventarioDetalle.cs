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
    
    public partial class AjusteInventarioDetalle
    {
        public int id { get; set; }
        public int idAjusteInventario { get; set; }
        public int IdMaterial { get; set; }
        public double Cantidad { get; set; }
    
        public virtual AjusteInventario AjusteInventario { get; set; }
    }
}