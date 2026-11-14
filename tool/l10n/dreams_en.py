"""Builds assets/content/en/dreams.json (sorted by English symbol). Same order of lines as the Polish file."""
import json, sys
ROWS = """Angel | A need for care and support, or a belief that someone is watching over you. | From whom or from what would you like support today?
Bus | A journey shared with others; living by someone else's timetable. | Are you going where you want to go, or where everyone else is going?
Grandmother | Family wisdom, warmth, tradition, or a longing for simplicity. | What advice would your grandmother give you now?
Balcony | A view from a distance; a wish to show yourself to the world. | What do you want to see from further away?
Bank | Resources, security, care for what you have built up. | What does your sense of security rest on?
Homelessness | A lack of support; a feeling that you have no place of your own. | Where do you truly feel at home?
White | Purity, a new beginning, but also an emptiness waiting to be filled. | What would you like to start with a clean slate?
Battle | An inner conflict or a dispute you are caught up in. | What are you really fighting for?
Mud | Being stuck; a feeling that things are sticky and slowing down. | What is slowing you down right now?
Stork | New life, a new project or news of a change. | What new thing wants to be born in you?
Brother | Rivalry, solidarity, or a quality you see in him. | Which of his qualities do you recognise in yourself?
Dirt | Something you consider untidy or shameful. | What do you want to clear out of your life?
Storm | Built-up tension looking for a way out. | Which emotions are waiting to be expressed?
Bottle | Emotions kept shut in; a message to pass on. | What are you keeping corked up?
Shoes | The road you are walking and your place in the world. | Do your shoes, your role, fit you well?
Being chased | Avoiding something that catches up with you anyway. | What would happen if you turned round and stood your ground?
Ex-partner | Unfinished business, or a quality you are looking for. | What did that relationship teach you?
Pregnancy | An idea, a plan or a change that is ripening and growing. | What is ripening in you?
Darkness | The unknown, fear, or a space you do not yet understand. | What do you not want to see yet?
Cemetery | Closed chapters, memory, farewell. | What has already ended and can be laid to rest?
Daughter | Your younger, sensitive side, or care for the future. | What are you caring for?
Sweets | Pleasure, reward, sometimes an escape from what is hard. | How are you rewarding yourself today?
Black cat | Superstition and fear of bad luck, or independence and mystery. | What are you afraid of without a clear reason?
Time (being late) | Pressure; a feeling that something is slipping away from you. | What do you really lack time for?
Rain | Cleansing, sadness, or nourishment after a drought. | What do you want to wash off yourself?
House | You yourself: the different rooms are different parts of your life. | Which room of that house do you visit least often?
Ladder | Promotion, successive stages, climbing towards a goal. | Which rung do you want to reach?
Tree | Growth, roots, family, stability. | What do you draw strength from, as a tree does from its roots?
Door | A new opportunity, a choice, a passage. | Which door do you want to open, and which to close?
Child | A new beginning, innocence, or your inner child. | What does your inner child need today?
Baby in your arms | Responsibility for something new and delicate. | What are you looking after today?
Exam | Being judged, fear of failure, testing yourself. | Who is really judging you: other people, or you?
Wave | Strong emotions that come and go. | Which wave of emotion are you riding right now?
Hunger | An unmet need, and not only a physical one. | What are you hungry for in life?
Mountain | A challenge, a goal, an obstacle or a wider view. | Which mountain are you climbing?
Mushrooms | Something growing out of sight; a gift of nature, or a call for caution. | What is quietly ripening?
Stars | Dreams, hope, guidance. | What do you long for?
Tea | A pause, comfort, a conversation with people close to you. | When did you last truly rest?
Swing | Mood swings; a return to childhood. | What are you wavering between?
Apple | Temptation, knowledge, health, the fruit of your work. | What fruit are you gathering from your efforts?
Egg | Potential, a beginning, something fragile to protect. | What fragile and promising thing are you protecting?
Lake | Calm, depth of feeling, a reflection of yourself. | What do you see when you look deep inside yourself?
Duck | Moving freely between worlds; lightness. | Where do you need more lightness?
Stone | Permanence, a weight, or a hardened heart. | What weighs on you like a stone?
Bath | Cleansing, recovery, looking after yourself. | How can you look after yourself?
Key | A solution, access, the uncovering of a secret. | What are you looking for the key to?
Argument | Tension that was not spoken aloud in waking life. | What do you want to say to someone?
Queue | Waiting your turn; patience. | What are you waiting for?
Horse | Strength, energy, freedom, forward drive. | Where is your energy carrying you?
Crown | Power, recognition, responsibility. | Where do you want to feel like a king or queen?
Church / temple | Spirituality, conscience, values. | What is sacred to you?
Cat | Independence, intuition, femininity, mystery. | Where do you need more independence?
Blood | Life force, family ties, a loss of energy. | What is draining your strength?
Scream | Unspoken emotions; a need to be heard. | What do you want to shout out?
Moon | Intuition, cycles, the feminine, hidden emotions. | What do you feel but not say?
Flowers | Blossoming, beauty, gratitude, feelings. | What is blossoming in your life?
Maze | Being lost, looking for the way, a complicated situation. | Which way out are you looking for?
Forest | The unknown, nature, intuition, sometimes being lost. | What are you looking for deep in the forest?
Forest at night | Fear of the unknown, but intuition too. | What do you trust when you cannot see anything?
Flying | Freedom, breaking away from limits, ambition. | What do you want to break away from?
Ice | Frozen feelings, coldness in a relationship, standstill. | What has frozen in you?
Mirror | Self-esteem, the truth about yourself, the way you see yourself. | What do you see in the mirror, and what do you want to see?
Boat | A journey through emotions; crossing to the other shore. | Where are you sailing to?
Tears | Relief, sadness, cleansing. | What is asking to be mourned?
Mother | Care, safety, the source, or the lack of it. | How can you surround yourself with care today?
City | Society, bustle, opportunity and anonymity. | Where is your place in the crowd?
Honey | Sweetness, a reward for work, tenderness. | What is your sweet reward?
Sea | The vastness of feeling, the unconscious, endless possibilities. | How deep are your feelings about this?
Bridge | A crossing, an understanding, the joining of two worlds. | Which two things do you want to bring together?
Butterfly | Transformation, lightness, the beauty of fleeting moments. | Which transformation are you going through?
Mouse | Small worries, shyness, hidden matters. | Which small worry has grown large in your mind?
Nakedness | Exposure, vulnerability, fear of being judged. | Where do you feel too exposed?
Sky | Hope, space, spirituality. | What do you want from life when there are no limits?
Knife | Cutting off, a decision, sharp words or conflict. | What do you want to cut away?
Wedding ring | Commitment, a relationship, being true to yourself. | What are you faithful to?
Ocean | A boundlessness of emotions and possibilities. | In that boundlessness, do you feel free or lost?
Fire | Passion, anger, transformation, purification. | What is burning in you?
Garden | Your life as a space to tend. | What in your garden needs attention today?
Father | Authority, rules, protection, or the lack of them. | Whose approval are you still looking for?
Window | A view of the world, perspective, hope. | What do you see outside your window?
Spider | Patience, weaving a web, sometimes a feeling of being trapped. | Which web are you caught in, or which are you weaving?
Sleep paralysis / being unable to move | Helplessness about something. Physiologically common on waking. | Where do you feel your hands are tied?
Money | Value, energy, self-worth. | How much, in your view, are you worth?
Dog | Loyalty, friendship, the instinct to protect. | Who are you loyal to, and who is loyal to you?
Beach | Rest; the border between dry land and emotion. | When will you allow yourself to rest?
Kiss | Closeness, acceptance, connection. | With whom or what do you want to grow closer?
Train | The direction of your life, a timetable, a track that is hard to leave. | Are you getting on the right train?
Funeral | The end of a stage; a farewell to something old. | What is ready to go?
House fire | Violent emotions, a crisis or a transformation. | What needs urgent attention?
Work | Duties, ambitions, everyday stress. | Is work taking up too much room in your life?
Gift | A surprise, appreciation, a talent. | Which gift are you discovering in yourself?
Bird | Freedom, a message, spiritual aspirations. | Which message do you want to send or receive?
Desert | Loneliness and barrenness, but also purification. | What are you missing, like water in the desert?
Wound | A hurt that needs attention. | What has not healed yet?
Family | Roots, bonds, the patterns you carry. | Which family pattern are you repeating?
Bicycle | Balance, moving under your own power, effort. | Where do you need to find your balance?
Rose | Love and beauty, but thorns too. | What thorns does the thing you love have?
Fish | Intuition, fertility, abundance, depth. | What are you fishing out of your subconscious?
River | The passing of time, transience, the current of life. | Are you going with the current or against it?
Car | Control over the direction of your life. | Who is driving: you, or someone else?
Aeroplane | Ambitions, rapid change, distant goals. | Where do you want to fly to?
Cheese | Temptation, reward, a small pleasure. | What do you fancy?
Heart | Feelings, love, courage. | What does your heart truly desire?
Sister | Closeness, rivalry, or a quality you see in her. | What connects you with the people who are as close as siblings?
Treasure | Hidden value, a talent, a discovery. | Which treasure do you carry within you?
Sun | Joy, energy, clarity, success. | What gives you light?
Owl | Wisdom, intuition, seeing in the dark. | What do you already know, though you have not admitted it yet?
Falling | Loss of control, uncertainty, fear of failure. | Where are you losing the ground under your feet?
Rat | Unease, small betrayals, or resourcefulness. | What is gnawing at you?
School | Learning, being assessed, old patterns and lessons. | Which lesson are you still learning?
Hospital | A need for recovery, care, healing. | What do you need in order to get better?
Wall | An obstacle, a boundary, protection. | What is blocking you, and is it protection or a prison?
Wedding ceremony | Union, commitment, bringing two parts of yourself together. | What do you want to bring together in yourself?
Death | The end of one stage and the start of another; rarely literal. | What is ending in your life?
Snow | Silence, purity, stillness, cold. | Where do you need quiet?
Dancing | Joy, harmony, the body expressing itself. | When did you last allow yourself joy?
Telephone | Communication, a message, contact with someone. | Who do you want to call?
Rainbow | Hope after a hard time; a promise. | What good came after the storm?
Drowning | Being overwhelmed by emotions or duties. | What is overwhelming you?
Bag / suitcase | The baggage of experience; what you carry with you. | What can you finally put down?
Coffin | A closed matter, a farewell, fear of the end. | What do you want to bring to a dignified close?
Running away | Avoiding a problem or an emotion. | What are you running from?
Bite | Being hurt by words; a feeling of being attacked. | Who or what has hurt you lately?
Beehive / bees | Industriousness, community, fruitful cooperation. | With whom do you make a well-matched team?
Holiday | A need for rest and freedom. | When will you plan a real break?
Snake | Transformation, renewal, hidden fear or wisdom. | Which skin are you ready to shed?
Wedding party | Celebration, union, community. | What do you want to celebrate?
Wind | Change, movement, something that cannot be stopped. | Which wind of change do you feel?
Wolf | Instinct, strength, the loyalty of the pack, or a threat. | Are you a lone wolf, or looking for a pack?
Lift | Rapid rises and falls; a change of level. | Which way are you going: up or down?
Hair | Strength, identity, image. | What do you want to change about how you present yourself?
Water | Emotions and the unconscious: clear water means calm, murky water means unease. | What is the water of your emotions like right now?
War | A major conflict, outer or inner. | With whom or what are you at war?
Teeth falling out | Fear of loss, of ageing, for your image; one of the most common dreams. | What are you afraid of losing?
Castle | A fortress, a sense of safety, or isolation. | What are you defending yourself against?
Betrayal | Fear of losing trust; uncertainty in a relationship. | Whom do you trust, and do you trust yourself too?
Clock | The passing of time, deadlines, pressure. | What is it high time for?
Getting lost | Lack of direction; uncertainty about a choice. | Which road are you looking for?
Lost object | The loss of something important: a thing, a relationship, a part of yourself. | What do you miss?
Gold | Value, success, what is precious in you. | What is your gold?
A loved one who has died | Longing, memory, an unfinished conversation. | What do you want to tell them?
Animals | The instincts and qualities you carry within you. | Which animal did you dream of, and what sets it apart?
Frog | Transformation, cleansing, beauty that is not obvious. | What in you can still be transformed?
Tortoise | Patience, slow progress, protection. | Where is it worth slowing down?"""
root = sys.argv[1]
rows = [[p.strip() for p in line.split(" | ")] for line in ROWS.split("\n")]
pl = json.load(open(f"{root}/assets/content/dreams.json", encoding="utf-8"))
assert len(rows) == len(pl) == 144 and all(len(r) == 3 for r in rows), len(rows)
assert len({r[0] for r in rows}) == 144, "duplicate symbols"
out = [{"symbol": s, "meaning": m, "reflection": q} for s, m, q in sorted(rows, key=lambda r: r[0].lower())]
open(f"{root}/assets/content/en/dreams.json", "w", encoding="utf-8").write(json.dumps(out, ensure_ascii=False, indent=1) + "\n")
print("ok", len(out))
