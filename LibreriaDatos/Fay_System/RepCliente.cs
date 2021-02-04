using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepCliente: Repositorio<Cliente>
    {
        public RepCliente(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTOCliente> ObtenerListaClientes()
        {
            return (from c in _contexto.Cliente
                    join p in _contexto.Persona on c.IdPersona equals p.Id
                    join es in _contexto.Estado on c.IdEstado equals es.Id
                    select new DTOCliente
                    {
                        IdCliente = c.IdCliente,
                        Dni = p.DNI,
                        ApellidoPaterno = p.ApellidoPaterno,
                        ApellidoMaterno = p.ApellidoMaterno,
                        Nombres = p.Nombres,
                        Direccion = p.Direccion,
                        Telefono = p.Telefono,
                        Estado = es.Descripcion,
                        Email = p.Email,
                        IdEstado=es.Id,

                    }).OrderByDescending(c => c.IdCliente).ToList();
        }

        public DTOCliente Obtener_DTOCliente_x_idCliente(int idCliente)
        {
            return (from c in _contexto.Cliente
                    join p in _contexto.Persona on c.IdPersona equals p.Id
                    join es in _contexto.Estado on c.IdEstado equals es.Id
                    join pr in _contexto.Provincia on p.IdProvincia  equals pr.IdProv
                    join de in _contexto.Departamento on pr.IdDepa equals de.IdDepa
                    where c.IdCliente == idCliente
                    select new DTOCliente
                    {
                        IdCliente = c.IdCliente,
                        Dni = p.DNI,
                        Nombres = p.Nombres,
                        ApellidoPaterno = p.ApellidoPaterno,
                        ApellidoMaterno = p.ApellidoMaterno,
                        FechaNacimiento = p.FechaNacimiento,
                        Email = p.Email,
                        Telefono = p.Telefono,
                        Direccion = p.Direccion,
                        Estado = es.Descripcion,
                        Ruc=p.Ruc,
                        Provincia = pr.ProvDescripcion,
                        Departamento = de.DepaDescripcion,
                        IdEstado = es.Id,
                        IdDepartamento = de.IdDepa,
                        IdProvincia = pr.IdProv,
                    })
                    .FirstOrDefault();
        }
        public List<ClientePersona> ListadoClientesDatosGenerales()
        {
            return (from c in _contexto.Cliente
                    join p in _contexto.Persona on c.IdPersona equals p.Id
                    join es in _contexto.Estado on c.IdEstado equals es.Id
                    select new ClientePersona
                    {
                        IdCliente = c.IdCliente,
                        ApelNom = p.ApellidoPaterno + " " + p.ApellidoMaterno + ", " + p.Nombres

                    }).OrderByDescending(c => c.IdCliente).ToList();
        }
        public class ClientePersona
        {
            public int IdCliente { get; set; }
            public string ApelNom { get; set; }
        }
    }
}
