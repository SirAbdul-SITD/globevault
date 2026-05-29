import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nation.dart';
import '../services/vault_service.dart';
import '../services/sound_service.dart';
import '../theme/gv_theme.dart';
import '../widgets/star_display.dart';
import 'debrief_view.dart';

class ChallengeView extends StatefulWidget {
  final Nation nation;
  const ChallengeView({super.key, required this.nation});
  @override State<ChallengeView> createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> with SingleTickerProviderStateMixin {
  int _idx = 0;
  int _score = 0;
  String? _selectedOption;
  String _typeInput = '';
  bool _revealed = false;
  bool? _correct;
  late AnimationController _feedbackCtrl;
  late Animation<Color?> _bgAnim;
  final _textController = TextEditingController();

  Challenge get _current => widget.nation.challenges[_idx];
  bool get _isMcq => _current.type == ChallengeType.mcq;

  @override
  void initState() {
    super.initState();
    _feedbackCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _bgAnim = ColorTween(begin: GVTheme.card, end: GVTheme.card)
        .animate(CurvedAnimation(parent: _feedbackCtrl, curve: Curves.easeInOut));
  }

  @override void dispose() { _feedbackCtrl.dispose(); _textController.dispose(); super.dispose(); }

  void _submitMcq(String option) {
    if (_revealed) return;
    setState(() {
      _selectedOption = option;
      _correct = option == _current.answer;
      _revealed = true;
      if (_correct!) _score++;
    });
    _animateFeedback(_correct!);
    _playSfx(_correct!);
  }

  void _submitTypeIn() {
    if (_revealed) return;
    final inp = _typeInput.trim().toLowerCase();
    final ans = _current.answer.toLowerCase();
    final correct = inp == ans || ans.contains(inp) && inp.length >= 3;
    setState(() { _correct = correct; _revealed = true; if (correct) _score++; });
    _animateFeedback(correct);
    _playSfx(correct);
  }

  void _animateFeedback(bool correct) {
    _bgAnim = ColorTween(
      begin: correct ? GVTheme.teal.withOpacity(0.18) : GVTheme.coral.withOpacity(0.18),
      end: GVTheme.card,
    ).animate(CurvedAnimation(parent: _feedbackCtrl, curve: Curves.easeInOut));
    _feedbackCtrl.forward(from: 0);
  }

  void _playSfx(bool correct) {
    final sfx = context.read<SoundService>();
    if (correct) sfx.correct(); else sfx.wrong();
  }

  void _next() {
    if (_idx < widget.nation.challenges.length - 1) {
      setState(() { _idx++; _selectedOption = null; _typeInput = ''; _revealed = false; _correct = null; });
      _textController.clear();
    } else {
      _finish();
    }
  }

  void _finish() async {
    final vault = context.read<VaultService>();
    final sfx   = context.read<SoundService>();
    final prev  = vault.starsFor(widget.nation.id);
    await vault.saveResult(widget.nation.id, _score);
    final newStars = vault.starsFor(widget.nation.id);
    if (newStars > prev) sfx.unlock();
    else sfx.complete();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => DebriefView(nation: widget.nation, score: _score, total: widget.nation.challenges.length)));
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.nation.challenges.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nation.emoji}  ${widget.nation.name}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_idx + (_revealed ? 1 : 0)) / total,
            backgroundColor: GVTheme.border,
            valueColor: const AlwaysStoppedAnimation(GVTheme.gold),
            minHeight: 5,
          ),
        ),
      ),
      body: Stack(children: [
        Positioned.fill(child: Image.asset('assets/backgrounds/bg_quiz.jpg', fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: GVTheme.bg))),
        Positioned.fill(child: Container(color: GVTheme.bg.withOpacity(0.88))),
        SafeArea(child: AnimatedBuilder(
          animation: _bgAnim,
          builder: (ctx, child) => Container(color: _bgAnim.value ?? Colors.transparent, child: child),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Question counter + score
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: GVTheme.card, borderRadius: BorderRadius.circular(20)),
                  child: Text('Question ${_idx + 1} of $total',
                    style: Theme.of(context).textTheme.bodyMedium),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: GVTheme.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: GVTheme.gold.withOpacity(0.3)),
                  ),
                  child: Text('$_score / $_idx pts',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GVTheme.gold)),
                ),
              ]),
              const SizedBox(height: 28),
              // Question card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: GVTheme.card, borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _revealed
                    ? (_correct! ? GVTheme.teal : GVTheme.coral).withOpacity(0.5)
                    : GVTheme.border)),
                child: Text(_current.text, style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(height: 1.45, fontSize: 17)),
              ),
              const SizedBox(height: 22),
              // Answer area
              Expanded(child: _isMcq ? _buildMcq() : _buildTypeIn()),
              const SizedBox(height: 16),
              // Next/Finish
              if (_revealed) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _correct! ? GVTheme.teal.withOpacity(0.12) : GVTheme.coral.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _correct! ? GVTheme.teal : GVTheme.coral, width: 0.8),
                  ),
                  child: Row(children: [
                    Icon(_correct! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: _correct! ? GVTheme.teal : GVTheme.coral, size: 22),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_correct! ? 'Correct!' : 'Not quite…',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _correct! ? GVTheme.teal : GVTheme.coral)),
                      if (!_correct!)
                        Text('Answer: ${_current.answer}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GVTheme.textPrimary)),
                    ])),
                  ]),
                ),
                const SizedBox(height: 14),
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: _next,
                  child: Text(_idx < total - 1 ? 'NEXT CHALLENGE' : 'SEE RESULTS',
                    style: const TextStyle(letterSpacing: 1)),
                )),
              ],
            ]),
          ),
        )),
      ]),
    );
  }

  Widget _buildMcq() {
    return Column(children: _current.options.map((opt) {
      Color bg = GVTheme.card;
      Color border = GVTheme.border;
      if (_revealed) {
        if (opt == _current.answer) { bg = GVTheme.teal.withOpacity(0.15); border = GVTheme.teal; }
        else if (opt == _selectedOption) { bg = GVTheme.coral.withOpacity(0.15); border = GVTheme.coral; }
      } else if (opt == _selectedOption) {
        bg = GVTheme.gold.withOpacity(0.12); border = GVTheme.gold;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () { context.read<SoundService>().tap(); _submitMcq(opt); },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border)),
            child: Text(opt, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      );
    }).toList());
  }

  Widget _buildTypeIn() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_current.hint.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(children: [
            const Icon(Icons.lightbulb_outline_rounded, color: GVTheme.gold, size: 16),
            const SizedBox(width: 6),
            Text('Hint: ${_current.hint}', style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: GVTheme.gold, fontStyle: FontStyle.italic)),
          ]),
        ),
      TextField(
        controller: _textController,
        enabled: !_revealed,
        style: Theme.of(context).textTheme.bodyLarge,
        textCapitalization: TextCapitalization.words,
        onChanged: (v) => setState(() => _typeInput = v),
        onSubmitted: (_) { if (!_revealed) _submitTypeIn(); },
        decoration: const InputDecoration(hintText: 'Type your answer…'),
      ),
      const SizedBox(height: 14),
      if (!_revealed)
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _typeInput.trim().isEmpty ? null : _submitTypeIn,
          child: const Text('SUBMIT'),
        )),
    ]);
  }
}
