using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace LibreriaDatos.Fay_System
{
    public class RepEmpleado:Repositorio<Empleado>
    {
        public RepEmpleado(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTOEmpleado> ObtenerListaEmpleados()
        {
            return (from e in _contexto.Empleado
                    join p in _contexto.Persona on e.IdPersona equals p.Id
                    join c in _contexto.Cargo on e.IdCargo equals c.Id 
                    join pr in _contexto.TipoProfesion on e.IdTipoProfesion equals pr.Id
                    join es in _contexto.Estado on e.IdEstado equals es.Id
                    where e.Id != 1
                    select new DTOEmpleado
                    {
                        Id = e.Id,
                        DNI = p.DNI,
                        RUC = p.Ruc,
                        Cargo = c.Descripcion,
                        Profesion = pr.Descripcion,
                        NombreCompleto = p.ApellidoPaterno + " " + p.ApellidoMaterno + ", " + p.Nombres,
                        Estado = es.Descripcion

                    }).OrderByDescending(e => e.Id).ToList();
        }

        public DTOEmpleado Obtener_DTOEmpleado_x_idEmpleado(int idEmpleado)
        {
            return (from e in _contexto.Empleado
                    join p in _contexto.Persona on e.IdPersona equals p.Id
                    join es in _contexto.Estado on e.IdEstado equals es.Id
                    join c in _contexto.Cargo on e.IdCargo equals c.Id
                    join tp in _contexto.TipoProfesion on e.IdTipoProfesion equals tp.Id
                    where e.Id == idEmpleado
                    select new DTOEmpleado
                    {
                        Id = e.Id,
                        RUC = p.Ruc,
                        Nombres = p.Nombres,
                        ApPaterno = p.ApellidoPaterno,
                        ApMaterno = p.ApellidoMaterno,
                        FechaNacimiento = p.FechaNacimiento,
                        Email = p.Email,
                        Telefono = p.Telefono,
                        Direccion = p.Direccion,
                        Estado = es.Descripcion,
                        IdEstado = es.Id,
                        IdCargo = c.Id,
                        IdProfesion = tp.Id,
                        Cargo = c.Descripcion,
                        Profesion = tp.Descripcion,
                        Sexo = p.Sexo,
                        DNI = p.DNI
                    })
                    .FirstOrDefault();
        }
        public DTOEmpleado Obtener_Empleado_x_IdPersona(int? IdPersona)
        {
            return (from e in _contexto.Empleado
                    join p in _contexto.Persona on e.IdPersona equals p.Id
                    where e.IdPersona == IdPersona
                    select new DTOEmpleado
                    {
                        Id = e.Id,
                        RUC = p.Ruc,
                        Nombres = p.Nombres,
                        ApPaterno = p.ApellidoPaterno,
                        ApMaterno = p.ApellidoMaterno,
                        FechaNacimiento = p.FechaNacimiento,
                        Email = p.Email,
                        Telefono = p.Telefono,
                        Direccion = p.Direccion,
                        Sexo = p.Sexo
                    })
                    .FirstOrDefault();
        }

    }
}
