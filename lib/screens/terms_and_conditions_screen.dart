import 'package:Wicore/dialogs/confirmation_dialog.dart';
import 'package:Wicore/styles/colors.dart';
import 'package:Wicore/styles/text_styles.dart';
import 'package:Wicore/widgets/reusable_app_bar.dart';
import 'package:Wicore/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsAgreementScreen extends StatefulWidget {
  const TermsAgreementScreen({Key? key}) : super(key: key);

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  bool _agreeAll = false;
  bool _agreeService = false;
  bool _agreePrivacy = false;
  bool _agreeLocation = false;

  bool get _isButtonEnabled => _agreeService && _agreePrivacy && _agreeLocation;

  void _updateAgreeAll() {
    setState(() {
      _agreeAll = _agreeService && _agreePrivacy && _agreeLocation;
    });
  }

  void _handleAgreeAllChanged(bool? value) {
    setState(() {
      _agreeAll = value ?? false;
      _agreeService = _agreeAll;
      _agreePrivacy = _agreeAll;
      _agreeLocation = _agreeAll;
    });
  }

  void _handleServiceChanged(bool? value) {
    setState(() {
      _agreeService = value ?? false;
    });
    _updateAgreeAll();
  }

  void _handlePrivacyChanged(bool? value) {
    setState(() {
      _agreePrivacy = value ?? false;
    });
    _updateAgreeAll();
  }

  void _handleLocationChanged(bool? value) {
    setState(() {
      _agreeLocation = value ?? false;
    });
    _updateAgreeAll();
  }

  void _showTermsDetails(String title) {
    // Navigate to terms detail screen or show dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text('$title의 상세 내용이 여기에 표시됩니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  void _handleConfirm() {
    if (_isButtonEnabled) {
      // Navigate to next screen (home or success screen)
      context.push('/sign-up-complete');
    }
  }

  Widget _buildCheckboxRow({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required TextStyle textStyle,
    bool showArrow = false,
    VoidCallback? onArrowTap,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.black,
              checkColor: CustomColors.limeGreen,
              side: BorderSide(color: Colors.grey[400]!, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: textStyle)),
          if (showArrow)
            GestureDetector(
              onTap: onArrowTap,
              child: const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '회원가입',
        onBackPressed: () => Navigator.pop(context),
        showTrailingButton: true,
        onTrailingPressed: () {
          ExitConfirmationDialogWithOptions.show(
            context,
            exitRoute: '/welcome',
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Title text
            Text('안전한 이용을 위해', style: TextStyles.kBody),
            const SizedBox(height: 8),
            Text('약관에 동의해주세요', style: TextStyles.kBody),

            const SizedBox(height: 24),

            // Subtitle text
            Text('동의하신 내용은 언제든지 앱에서', style: TextStyles.kMedium),
            const SizedBox(height: 4),
            Text('다시 확인하실 수 있어요.', style: TextStyles.kMedium),

            const SizedBox(height: 60),

            // Agree all checkbox
            _buildCheckboxRow(
              title: '전체동의',
              textStyle: TextStyles.kSemiBold,
              value: _agreeAll,
              onChanged: _handleAgreeAllChanged,
              isBold: true,
            ),

            // Divider line
            const Divider(height: 32, thickness: 1, color: Color(0xFFE0E0E0)),

            // Individual agreement checkboxes
            _buildCheckboxRow(
              title: '[필수] 서비스 이용 약관',
              textStyle: TextStyles.kRegular,
              value: _agreeService,
              onChanged: _handleServiceChanged,
              showArrow: true,
              onArrowTap: () => _showTermsDetails('서비스 이용 약관'),
            ),

            _buildCheckboxRow(
              title: '[필수] 개인정보 수집 및 이용 동의',
              textStyle: TextStyles.kRegular,
              value: _agreePrivacy,
              onChanged: _handlePrivacyChanged,
              showArrow: true,
              onArrowTap: () => _showTermsDetails('개인정보 수집 및 이용 동의'),
            ),

            _buildCheckboxRow(
              title: '[선택] 위치 정보 수집 동의',
              textStyle: TextStyles.kRegular,
              value: _agreeLocation,
              onChanged: _handleLocationChanged,
              showArrow: true,
              onArrowTap: () => _showTermsDetails('위치 정보 수집 동의'),
            ),

            const Spacer(),

            // Confirm button
            CustomButton(
              text: '확인',
              isEnabled: _isButtonEnabled,
              onPressed: _isButtonEnabled ? _handleConfirm : null,
              disabledBackgroundColor: Colors.grey,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
