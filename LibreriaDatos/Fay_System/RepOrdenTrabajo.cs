using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepOrdenTrabajo : Repositorio<OrdenTrabajo>
    {
        public RepOrdenTrabajo(FayceEntities contexto) : base(contexto)
        {

        }

        public List<DTOOrdenesTrabajo> ObtenerListaOrdenesTrabajo()
        {
            return ((from ot in _contexto.OrdenTrabajo
                     join e in _contexto.Empleado on ot.IdEjecutivo equals e.Id
                     join pe in _contexto.Persona on e.IdPersona equals pe.Id
                     join es in _contexto.Estado on ot.IdEstado equals es.Id
                     join c in _contexto.Cliente on ot.IdClienteNatural equals c.IdCliente
                     join pc in _contexto.Persona on c.IdPersona equals pc.Id
                     join ovd in _contexto.OrdenVentaDetalle on ot.IdOrdenVentaDetalle equals ovd.Id
                     join ov in _contexto.OrdenVenta on ovd.IdOrdenVenta equals ov.Id
                     select new DTOOrdenesTrabajo
                     {
                         Id = ot.IdOrdenTrabajo,
                         Trabajo = ot.Trabajo,
                         FechaEmision = ot.FechaEmision,
                         FechaEntregaO = ot.FechaEntregaO,
                         Estado = es.Descripcion,
                         FechaEntregaF = ot.FechaEntregaF,
                         DatosEjecutivo = pe.ApellidoPaterno + " " + pe.ApellidoMaterno + ", " + pe.Nombres,
                         DatosCliente = pc.ApellidoPaterno + " " + pc.ApellidoMaterno + ", " + pe.Nombres,
                         IdOrdenVenta = ov.Id

                     }).Concat(
                from ot in _contexto.OrdenTrabajo
                join e in _contexto.Empleado on ot.IdEjecutivo equals e.Id
                join pe in _contexto.Persona on e.IdPersona equals pe.Id
                join es in _contexto.Estado on ot.IdEstado equals es.Id
                join c in _contexto.Empresa on ot.IdClienteJuridico equals c.Id
                join pc in _contexto.Persona on c.IdPersona equals pc.Id
                join ovd in _contexto.OrdenVentaDetalle on ot.IdOrdenVentaDetalle equals ovd.Id
                join ov in _contexto.OrdenVenta on ovd.IdOrdenVenta equals ov.Id
                select new DTOOrdenesTrabajo
                {
                    Id = ot.IdOrdenTrabajo,
                    Trabajo = ot.Trabajo,
                    FechaEmision = ot.FechaEmision,
                    FechaEntregaO = ot.FechaEntregaO,
                    Estado = es.Descripcion,
                    FechaEntregaF = ot.FechaEntregaF,
                    DatosEjecutivo = pe.ApellidoPaterno + " " + pe.ApellidoMaterno + ", " + pe.Nombres,
                    DatosCliente = pc.RazonSocial,
                    IdOrdenVenta = ov.Id

                })
                    ).OrderByDescending(o => o.Id).ToList();
        }

        public List<DTOOrdenesTrabajo> ObtenerListaOrdenesTrabajo_SalidaMateriales()
        {
            return ((from ot in _contexto.OrdenTrabajo
                     join e in _contexto.Empleado on ot.IdEjecutivo equals e.Id
                     join pe in _contexto.Persona on e.IdPersona equals pe.Id
                     join es in _contexto.Estado on ot.IdEstado equals es.Id
                     join c in _contexto.Cliente on ot.IdClienteNatural equals c.IdCliente
                     join pc in _contexto.Persona on c.IdPersona equals pc.Id
                     join ovd in _contexto.OrdenVentaDetalle on ot.IdOrdenVentaDetalle equals ovd.Id
                     join ov in _contexto.OrdenVenta on ovd.IdOrdenVenta equals ov.Id
                     select new DTOOrdenesTrabajo
                     {
                         Id = ot.IdOrdenTrabajo,
                         Trabajo = ot.Trabajo,
                         DatosCliente = pc.ApellidoPaterno + " " + pc.ApellidoMaterno + ", " + pe.Nombres,

                     }).Concat(
                from ot in _contexto.OrdenTrabajo
                join e in _contexto.Empleado on ot.IdEjecutivo equals e.Id
                join pe in _contexto.Persona on e.IdPersona equals pe.Id
                join es in _contexto.Estado on ot.IdEstado equals es.Id
                join c in _contexto.Empresa on ot.IdClienteJuridico equals c.Id
                join pc in _contexto.Persona on c.IdPersona equals pc.Id
                join ovd in _contexto.OrdenVentaDetalle on ot.IdOrdenVentaDetalle equals ovd.Id
                join ov in _contexto.OrdenVenta on ovd.IdOrdenVenta equals ov.Id
                select new DTOOrdenesTrabajo
                {
                    Id = ot.IdOrdenTrabajo,
                    Trabajo = ot.Trabajo,
                    DatosCliente = pc.RazonSocial,

                })
                    ).OrderByDescending(o => o.Id).ToList();
        }

        public int ObtenerOrdenVentaId_x_IdOrdenTrabajo(int IdordenTrabajo)
        {
            return (from ot in _contexto.OrdenTrabajo
                    join ovd in _contexto.OrdenVentaDetalle on ot.IdOrdenVentaDetalle equals ovd.Id
                    where ot.IdOrdenTrabajo == IdordenTrabajo
                    select ovd.IdOrdenVenta).FirstOrDefault();
        }
    }
}
