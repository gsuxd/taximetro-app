import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malibu/blocs/auth/auth_bloc.dart';
import 'package:malibu/icons/google_icon_icons.dart';

final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _viewForm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SizedBox(
            width: double.infinity,
            child: orientation == Orientation.portrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: AppBar().preferredSize.height,
                      ),
                      Flexible(
                        flex: 1,
                        child: _Title(),
                      ),
                      Flexible(
                        flex: 2,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 800),
                          child: _viewForm
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 0),
                                  child: _Form(
                                    onReturn: () {
                                      setState(() {
                                        _viewForm = false;
                                      });
                                    },
                                  ),
                                )
                              : _SecondPart(
                                  orientation: orientation,
                                  onViewForm: () {
                                    setState(() {
                                      _viewForm = true;
                                    });
                                  },
                                ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Flexible(
                        flex: 1,
                        child: _Title(),
                      ),
                      Flexible(
                        flex: 2,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 800),
                          child: _viewForm
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      vertical: 0),
                                  child: _Form(
                                    onReturn: () {
                                      setState(() {
                                        _viewForm = false;
                                      });
                                    },
                                  ),
                                )
                              : _SecondPart(
                                  orientation: orientation,
                                  onViewForm: () {
                                    setState(() {
                                      _viewForm = true;
                                    });
                                  },
                                ),
                        ),
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _SecondPart extends StatelessWidget {
  final Orientation orientation;
  final Function() onViewForm;
  const _SecondPart({required this.orientation, required this.onViewForm});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: orientation == Orientation.portrait
                ? 12.0
                : MediaQuery.of(context).size.width * 0.14,
          ),
          child: Column(
            children: [
              InkWell(
                key: const Key('goLoginButton'),
                onTap: onViewForm,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Iniciar sesión',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Text(
                    'Registrarse',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _Footer(),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _Form extends StatefulWidget {
  final Function() onReturn;
  const _Form({required this.onReturn});
  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  bool _viewPassword = false;
  Map<String, String> data = {
    'email': '',
    'password': '',
  };
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Wrap(
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  return 'El correo electrónico es requerido';
                }
                if (!(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val))) {
                  return 'El correo electrónico no es válido';
                }
                return null;
              },
              onSaved: (val) {
                data['email'] = val!;
              },
              key: const Key('emailField'),
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'Ingresa tu correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
              ),
            ),
            TextFormField(
              onSaved: (val) {
                data['password'] = val!;
              },
              validator: (val) {
                if (val!.isEmpty) {
                  return 'La contraseña es requerida';
                }
                if (val.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
              key: const Key('passwordField'),
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_viewPassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingresa tu contraseña',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _viewPassword = !_viewPassword;
                    });
                  },
                  child: _viewPassword
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
              ),
            ),
            InkWell(
              key: const Key('loginButton'),
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  context.read<AuthBloc>().add(
                        AuthLoginEvent(
                          data['email']!.trim(),
                          data['password']!.trim(),
                        ),
                      );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Iniciar sesión',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            TextButton(onPressed: widget.onReturn, child: const Text('Volver'))
          ],
        ));
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: const Icon(
                Icons.facebook,
                color: Colors.blue,
                size: 50,
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  GoogleIcon.google_circle_svgrepo_com,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Taximetro',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text(
          'Iniciar sesión',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        )
      ],
    );
  }
}
