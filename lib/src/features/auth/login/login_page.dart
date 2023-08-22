import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';
import 'package:dw_barbershop/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/helpers/messages.dart';
import 'login_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose(){
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final LoginVm(:login) = ref.watch(loginVmProvider.notifier);

    ref.listen(loginVmProvider, (previous, state){
      switch(state){
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showError(context, errorMessage);
          break;
        case LoginState(status: LoginStateStatus.error):
          Messages.showError(context, 'Erro desconhecido');
          break;
        case LoginState(status: LoginStateStatus.admLogin):
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home/adm', (route) => false);
          break;
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home/employee', (route) => false);
          break;
      }
    });

    return Scaffold(
        backgroundColor: Colors.black,
        body: Form(
          key: formKey,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  ImageConstants.backGroundChair,
                ),
                opacity: 0.2,
                fit: BoxFit.cover),
            ),
           child: Padding(
             padding: const EdgeInsets.all(30.0),
             child: CustomScrollView(
               slivers: [
                 SliverFillRemaining(
                   hasScrollBody: false,
                   child: Stack(
                     alignment: Alignment.center,
                     children: [
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children:[
                           Image.asset(ImageConstants.imageLogo),
                           const SizedBox(
                             height: 24,
                           ),
                           TextFormField(
                             onTapOutside: (_) => context.unfocus(),
                             validator: Validatorless.multiple([
                               Validatorless.required('E-mail obrigatório'),
                               Validatorless.email('E-mail Inválido')
                             ]),
                             controller: emailEC,
                             decoration: const InputDecoration(
                               label:Text('E-mail'),
                               hintText: 'E-mail',
                               floatingLabelBehavior: FloatingLabelBehavior.never,
                               labelStyle: TextStyle(color: Colors.black)
                             ),
                           ),
                           const SizedBox(
                             height: 24,
                           ),
                           TextFormField(
                             onTapOutside: (_) => context.unfocus(),
                             validator: Validatorless.multiple([
                               Validatorless.required('Senha obrigatória'),
                               Validatorless.email('Senha deve conter pelo menos 6 caracteres')
                             ]),
                             obscureText: true,
                             controller: passwordEC,
                             decoration: const InputDecoration(
                                 label:Text('Senha'),
                                 hintText: 'Senha',
                                 floatingLabelBehavior: FloatingLabelBehavior.never,
                                 labelStyle: TextStyle(color: Colors.black)
                             ),
                           ),
                           const SizedBox(
                             height: 16,
                           ),
                           const Align(
                             alignment: Alignment.centerLeft,
                             child: Text('Esqueceu a senha?',
                             style: TextStyle(
                               fontSize: 12,
                               color: ColorsConstants.brow
                             ),
                             ),
                           ),
                           const SizedBox(
                             height: 24,
                           ),
                           ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               minimumSize: const Size.fromHeight(56)
                             ),
                             onPressed: (){
                               switch(formKey.currentState?.validate()){
                                 case true:
                                   login(
                                     emailEC.text,
                                     passwordEC.text
                                   );
                                   break;
                                 case (false || null):
                                   Messages.showError(context, 'Campos inválidos');
                                   break;
                               }
                             },
                             child: const Text('ACESSAR'),
                           )
                         ],
                       ),
                       Align(
                         alignment: Alignment.bottomCenter,
                         child: InkWell(
                           onTap: (){
                             Navigator.of(context).pushNamed('/auth/register/user');
                           },
                           child: const Text('Criar conta',style: TextStyle(
                               fontSize: 16,
                               color: Colors.white,
                               fontWeight: FontWeight.w500),
                           ),
                         ),
                       )
                     ],
                   ),
                 )
               ],
             ),
           ),
          ),
        ),
    );
  }
}