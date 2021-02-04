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
    
    public partial class Egresos
    {
        public int IdEgreso { get; set; }
        public string Motivo { get; set; }
        public Nullable<decimal> Monto { get; set; }
        public Nullable<int> IdEmpleado { get; set; }
        public Nullable<int> IdUsuario { get; set; }
        public Nullable<int> IdEstado { get; set; }
        public Nullable<System.DateTime> FechaCreacion { get; set; }
        public Nullable<int> IdUsuarioEliminacion { get; set; }
        public Nullable<System.DateTime> FechaEliminacion { get; set; }
    
        public virtual Empleado Empleado { get; set; }
        public virtual Estado Estado { get; set; }
        public virtual Usuario Usuario { get; set; }
    }
}