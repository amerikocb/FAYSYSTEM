using LibreriaDatos.DTO;
using System.Collections.Generic;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepEgreso:Repositorio<Egresos>
    {
        public RepEgreso(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTOEgreso> ObtenerListaEgresos()
        {
            return (from eg in _contexto.Egresos
                    join u in _contexto.Usuario on eg.IdUsuario equals u.id
                    join em in _contexto.Empleado on eg.IdEmpleado equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    join es in _contexto.Estado on eg.IdEstado equals es.Id
                    select new DTOEgreso
                    {
                        Id = eg.IdEgreso,
                        Empleado = p.ApellidoPaterno + " " + p.ApellidoMaterno + ", " + p.Nombres,
                        Usuario = u.Nombre,
                        Estado = es.Descripcion,
                        Fecha = eg.FechaCreacion,
                        Monto = eg.Monto,
                        Motivo = eg.Motivo
                    }).OrderByDescending(egr => egr.Id).ToList();
        }
    }
}
