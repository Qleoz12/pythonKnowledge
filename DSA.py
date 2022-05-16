from random import randrange
from hashlib import sha256
from gmpy2 import xmpz, to_binary, invert, powmod, is_prime


def generate_p_q(L, N):
    g = N  # g >= 160
    n = (L - 1) // g
    b = (L - 1) % g
    while True:
        # generate q
        while True:
            s = xmpz(randrange(1, 2 ** (g)))
            a = sha256(to_binary(s)).hexdigest()
            zz = xmpz((s + 1) % (2 ** g))
            z = sha256(to_binary(zz)).hexdigest()
            U = int(a, 16) ^ int(z, 16)
            mask = 2 ** (N - 1) + 1
            q = U | mask
            if is_prime(q, 20):
                break
        # generate p
        i = 0  # counter
        j = 2  # offset
        while i < 4096:
            V = []
            for k in range(n + 1):
                arg = xmpz((s + j + k) % (2 ** g))
                zzv = sha256(to_binary(arg)).hexdigest()
                V.append(int(zzv, 16))
            W = 0
            for qq in range(0, n):
                W += V[qq] * 2 ** (160 * qq)
            W += (V[n] % 2 ** b) * 2 ** (160 * n)
            X = W + 2 ** (L - 1)
            c = X % (2 * q)
            p = X - c + 1  # p = X - (c - 1)
            if p >= 2 ** (L - 1):
                if is_prime(p, 10):
                    return p, q
            i += 1
            j += n + 1


def generate_g(p, q):
    while True:
        h = randrange(2, p - 1)
        exp = xmpz((p - 1) // q)
        g = powmod(h, exp, p)
        if g > 1:
            break
    return g


def generate_keys(g, p, q):
    x = randrange(2, q)  # x < q
    y = powmod(g, x, p)
    return x, y


def generate_params(L, N):
    p, q = generate_p_q(L, N)
    g = generate_g(p, q)
    return p, q, g


def sign(M, p, q, g, x):
    if not validate_params(p, q, g):
        raise Exception("Invalid params")
    while True:
        k = randrange(2, q)  # k < q
        r = powmod(g, k, p) % q
        m = int(sha256(M).hexdigest(), 16)
        # print("valor de m en sha 256")
        # print(m)
        # print("valor de m en sha 256")
        try:
            s = (invert(k, q) * (m + x * r)) % q
            return r, s
        except ZeroDivisionError:
            pass


def verify(M, r, s, p, q, g, y):
    if not validate_params(p, q, g):
        raise Exception("Invalid params")
    if not validate_sign(r, s, q):
        return False
    try:
        w = invert(s, q)
    except ZeroDivisionError:
        return False
    m = int(sha256(M).hexdigest(), 16)
    # print("valor de m en sha 256")
    # print(m)
    # print("valor de m en sha 256")
    u1 = (m * w) % q
    u2 = (r * w) % q
    # v = ((g ** u1 * y ** u2) % p) % q
    v = (powmod(g, u1, p) * powmod(y, u2, p)) % p % q
    if v == r:
        return True
    return False


def validate_params(p, q, g):
    if is_prime(p) and is_prime(q):
        return True
    if powmod(g, q, p) == 1 and g > 1 and (p - 1) % q:
        return True
    return False


def validate_sign(r, s, q):
    if r < 0 and r > q:
        return False
    if s < 0 and s > q:
        return False
    return True


def dsa_sign(N,L,text):
    # N = 256
    # L = 3072
    p, q, g = generate_params(L, N)
    x, y = generate_keys(g, p, q)
    M = str.encode(text, "ascii")
    r, s = sign(M, p, q, g, x)

    return {"r"  : r,
            "s"  : s,
            "p" : p,
            "q"  : q,
            "g"  : g,
            "public" : y,
            "private": x}

def dsa_verify(text,r,s,p, q, g, y):
    M = str.encode(text, "ascii")
    if verify(M, r, s, p, q, g, y):
        print('All ok')
        return True

    return False

if __name__ == "__main__":


    text = "The standard Lorem Ipsum passage, used since the 1500s" \
           "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et " \
           "dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip " \
           "ex ea commodo" \
           "consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla " \
           "pariatur." \
           "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est " \
           "laborum.\"" \
           "Section 1.10.32 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BC" \
           "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, " \
           "totam rem aperiam, " \
           "eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam " \
           "voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui " \
           "ratione" \
           " voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci" \
           " velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem." \
           " Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea" \
           " commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil " \
           "molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\"" \
           "translation by H. Rackham" \
           "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will " \
           "give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, " \
           "the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure," \
           " but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely " \
           "painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, " \
           "but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a" \
           " trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? " \
           "But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, " \
           "or one who avoids a pain that produces no resultant pleasure? Section 1.10.33 of \"de Finibus Bonorum et Malorum\", " \
           "written by Cicero in 45 BC At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium " \
           "voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident," \
           " similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum " \
           "facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo" \
           " minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem" \
           " quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et " \
           "molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores" \
           " alias consequatur aut perferendis doloribus asperiores repellat. 1914 translation by H. Rackham" \
           "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the" \
           " charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are" \
           " bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same" \
           " as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. " \
           "In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what " \
           "we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing " \
           "to the claims of duty or the obligations of business it will frequently occur that pleasures have to be " \
           "repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of " \
           "selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid " \
           "worse pains.\" "

    data=dsa_sign(256,3072,text)
    # print(r,s,p, q, g, y,x,sep="  -   \n")
    dsa_verify(text, data["r"], data["s"], data["p"], data["q"], data["g"], data["public"])

