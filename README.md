# Fixer

## File Structure

./src/ contains the _library_ code, i.e the functions the server triggers on different endpoints

./exec/ contains the _application_ code, in this case the server itself

The project uses stack's Docker integration, with default settings (no custom images etc).

To build, execute:

`stack build`

To run:

`stack --docker-run-args='--net=bridge --publish=3000:3000' exec fixer-server`


